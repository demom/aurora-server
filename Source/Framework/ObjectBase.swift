import Foundation
import Kitura
import SwiftyJSON
import LoggerAPI
import PostgreSQL

open class ObjectBase {

	public var name: String = ""
	public var structure: [String: String] = [:]
	public var data: [String: Any] = [:]
	let db = PGConnection()

	open func setup() {}

	public required init() {
		print(db.connectdb(Config.connectionInfo))
		self.setup()
	}

	public func list() {
		print("List")
	}

	public func open(id: String) {
		print("Opening " + id)
		let result = db.exec(statement: "SELECT * FROM \"" + name + "\" WHERE \"id\" = $1", params: [id])
		
		let numberOfRows = result.numTuples()
		let numberOfFields = result.numFields()

		print(String(numberOfRows) + " rows matched search")

		var fieldNames: [Int:String] = [:]
		var fieldTypes: [Int:String] = [:]

		for y in 0..<numberOfFields {
			fieldNames[y] = result.fieldName(index: y)
			fieldTypes[y] = structure[fieldNames[y]!]
		}

		for x in 0..<numberOfRows {
			for y in 0..<numberOfFields {
				switch (fieldTypes[y]!) {
					case "uuid":
						data[fieldNames[y]!] = result.getFieldString(tupleIndex: x, fieldIndex: y)
					case "int":
						data[fieldNames[y]!] = result.getFieldInt(tupleIndex: x, fieldIndex: y)
					case "long":
						data[fieldNames[y]!] = result.getFieldInt64(tupleIndex: x, fieldIndex: y)
					case "bool":
						data[fieldNames[y]!] = result.getFieldBool(tupleIndex: x, fieldIndex: y)
					case "timestamp":
						data[fieldNames[y]!] = result.getFieldString(tupleIndex: x, fieldIndex: y)
					default:
						data[fieldNames[y]!] = result.getFieldString(tupleIndex: x, fieldIndex: y)
				}
			}
		}
	}

	public func create() {
		print("Create")
	}

	public func update(id: String) {
		print("Updating " + id)
	}

	public func delete(id: String) {
		print("Deleting " + id)
	}

	public func toJson() -> JSON {
		return JSON([name: data])
	}

	public func fromJson(json: JSON) {
		data["id"] = 123
		data["name"] = "allan"
	}
}