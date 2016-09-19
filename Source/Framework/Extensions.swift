import Foundation
import Kitura
import LoggerAPI
import SwiftyJSON

extension RouterRequest {
    
    public var json: JSON? {
        
        guard let body = self.body else {
            Log.warning("No body in the message")
            return nil
        }
        
        guard case let .json(json) = body else {
            Log.warning("Body was not formed as JSON")
            return nil
        }
        
        return json
    }
}