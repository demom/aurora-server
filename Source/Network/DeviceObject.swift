import Foundation
import Framework


public class DeviceObject: ObjectBase {
	public override func setup() {
		self.name = "Device"

		structure = [
			"id": "uuid",
			"name": "string",
			"vendor": "string",
			"model": "string",
			"serialnumber": "string",
			"type": "string",
			"created": "timestamp",
			"updated": "timestamp"
		]
	}

}