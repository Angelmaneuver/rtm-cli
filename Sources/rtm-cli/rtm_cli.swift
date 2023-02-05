import Foundation
import ArgumentParser
import RTM
import ArkanaKeys

@main
struct rtm_cli: ParsableCommand {
    public static var configuration = CommandConfiguration(
        abstract: "A command line tool that provides a request URL to the Remember The Milk API based on input parameters. * This product uses the Remember The Milk API but is not endorsed or certified by Remember The Milk."
    )

	enum Methods: String {
		case checkToken, getFrob, getToken, getList

		var transfer: RtmMethod {
			switch self {
				case .checkToken:
					return RTM.Methods.Auth.checkToken
				case .getFrob:
					return RTM.Methods.Auth.getFrob
				case .getToken:
					return RTM.Methods.Auth.getToken
				case .getList:
					return RTM.Methods.Tasks.getList
			}
		}
	}

	enum InvalidParameterError:LocalizedError {
		case key, secret, noSupportedMethod

		var errorDescription:String? {
			switch self {
				case .key:
					return "API Key has not been entered."
				case .secret:
					return "API Secret has not been entered."
				case .noSupportedMethod:
					return "The specified method is not supported."
			}
		}
	}

	struct ConfidentialOption: ParsableArguments {
		@Option(help: "Enter when specifying the API Key used for URL assembly.")
		var key:    String = ""

		@Option(help: "Enter when specifying the API Secret used for URL assembly.")
		var secret: String = ""

		func validate() throws {
			if (0 == key.count && 0 != secret.count) {
				throw InvalidParameterError.key
			} else if (0 != key.count && 0 == secret.count) {
				throw InvalidParameterError.secret
			}
		}
	}

	@OptionGroup
	var confidential: ConfidentialOption

	@Option(help: "Enter the Frob obtained from Remember The Milk.")
	var frob: String = ""

	@Option(help: "Enter the Auth Token obtained from Remember The Milk.")
	var token: String = ""

	@Option(help: "Task acquisition conditions.")
	var filter: String = ""

	struct MethodOption: ParsableArguments {
		@Argument(help: "Specify the method of the request URL to be retrieved.")
		var method: String

		func validate() throws {
			if ("auth" != method && rtm_cli.Methods(rawValue: method)?.rawValue == nil) {
				throw InvalidParameterError.noSupportedMethod
			}
		}
	}

	@OptionGroup
	var method: MethodOption

	public mutating func run() throws {
		let appKey:    String = 0 < confidential.key.count    ? confidential.key    : ArkanaKeys.Keys.Global().apiKey
		let appSecret: String = 0 < confidential.secret.count ? confidential.secret : ArkanaKeys.Keys.Global().apiSecret
		let authToken: String = token
		var rtm:       RTM

		do {
			rtm = try RTM(appKey: appKey, appSecret: appSecret, authToken: authToken)
		} catch {
			throw error
		}

		if ("auth" == method.method) {
			print(rtm.getAuthUrl(frob: frob))
		} else {
			var params: Dictionary<String, String> = [:]

			if (0 < frob.count) {
				params.updateValue(frob,   forKey: "frob")
			}

			if (0 < filter.count) {
				params.updateValue(filter, forKey: "filter")
			}

			print(rtm.getUrl(method:  rtm_cli.Methods(rawValue: method.method)!.transfer, params))
		}
	}
}
