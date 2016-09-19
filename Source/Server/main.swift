import Foundation
import Kitura
import SwiftyJSON
import LoggerAPI
import HeliumLogger

import Framework
import Network

#if os(Linux)
    import Glibc
#endif


// This is our router
let router = Router()

// And this is our logger
Log.logger = HeliumLogger()

// Here goes the middlewares
router.all(middleware: BasicAuthMiddleware())
router.all("/resources", middleware: StaticFileServer())
router.all(middleware: BodyParser())

// Parse request
router.all  { request, response, next in

    if request.originalURL == "/" || request.originalURL == "" {
        response.send(json: JSON("Aurora Web Services"))
        next()
    }

    let arr = request.originalURL.components(separatedBy: "/")
    
    if (arr.count >= 4 && arr[2] == "Object") {
        let modulename = arr[1]
        let type = arr[2]
        let action = arr[3]
        var id = ""

        if arr.count > 4 {
            id = arr[4]
        }

        let namespace = modulename + "." + action + type

        if let obj = Framework.ObjectFactory.loadObjectFromString(className: namespace) {

            switch (request.method) {
                case RouterMethod.get:
                    if id == "" {
                        obj.list()
                    } else {
                        obj.open(id: id)
                    }

                    response.send(json: obj.toJson())
                    next()

                case RouterMethod.post:
                    if let json = request.json {
                        obj.fromJson(json: request.json!)
                        obj.create()
                        response.send(json: obj.toJson())
                        next()
                    }
                    
                    try response.status(.badRequest).send(json: JSON(["errors": "Request body was not a JSON document"])).end()
                    next()
                    
                case RouterMethod.put:
                    if let json = request.json {
                        obj.fromJson(json: request.json!)
                        obj.update(id: id)
                        response.send(json: obj.toJson())
                        next()
                    }
                    
                    try response.status(.badRequest).send(json: JSON(["errors": "Request body was not a JSON document"])).end()
                    next()

                case RouterMethod.delete:
                    obj.delete(id: id)
                    response.send(json: obj.toJson())
                    next()
                default:
                    Log.warning("Unknown request method")
            }
        }
    }

    try response.status(.notFound).send(json: JSON(["errors": "Route was not found"])).end()
    next()
}

// Aurora Server is both a standalone HTTP server and
// a FastCGI server for integration with apache2/nginx
Kitura.addHTTPServer(onPort: 8080, with: router)
Kitura.addFastCGIServer(onPort: 9000, with: router)

// Lets go!
Kitura.run()