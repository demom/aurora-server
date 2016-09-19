import Foundation
import Kitura
import LoggerAPI
import HeliumLogger

#if os(Linux)
    import Glibc
#endif

class BasicAuthMiddleware: RouterMiddleware {
    func handle(request: RouterRequest, response: RouterResponse, next: @escaping () -> Void) {
        let authString = request.headers["Authorization"]
        Log.info("Authorization: \(authString)")
        // Check authorization string in database to approve the request if fail
        // response.error = NSError(domain: "AuthFailure", code: 1, userInfo: [:])
        next()
    }
}