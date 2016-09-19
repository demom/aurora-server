import Foundation


/**
    Factory for creating objects from strings
*/
public class ObjectFactory {

    /**
        Loads class from string containing full class name

        - parameter className: Name of class, ex. ModuleName.ClassName

        - returns: Object instance of class
    */
    public static func loadObjectFromString(className: String) -> ObjectBase? {

        let objectType: ObjectBase.Type? = NSClassFromString(className) as? ObjectBase.Type;

        if objectType == nil {
            return nil
        }

        let loader: ObjectBase? = objectType!.init();

        return loader;
    }

    /**
        Does not work as of now
    */
    public static func getStringFromClass(classType: AnyClass) -> String {
        return NSStringFromClass(classType);
    }
}