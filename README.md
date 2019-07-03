# Steering

### Inspiration

If you have ever used [`Moya`](https://github.com/Moya/Moya) it will come as no suprise that this library pulls massive inspiration from it. From the public API down to the documentation `Steering` borrows many queues from `Moya`.

Where `Steering` differs from `Moya` is in their dependency graph.

`Moya's` Dependencies
* [`Alamofire`](https://github.com/Alamofire/Alamofire)
* [`Result`](https://github.com/antitypical/Result)
* [`ReactiveSwift`](https://github.com/ReactiveCocoa/ReactiveSwift)
* [`RxSwift`](https://github.com/ReactiveX/RxSwift)

The reason for `Steering's` construction was to aleviate the weight associated with `Moya's` dependencies.

`Steering's` Dependencies
* [`Tyre`](https://github.com/christianampe/tyre)

It is clear that `Steering` is a much lighter-weight layer which wraps up `Tyre` which is effectively `Alamofire's` simplest method for making a network request.

With this said, `Moya's` dependencies are all battle-tested and `Moya` as a whole is a far more robust dependency currently. 

### Basic Usage

So how do you use this library? Well, it's pretty easy. Just follow this template. 

First, set up an `enum` with all of your API targets. Note that you can include information as part of your enum. Let's look at a common example. First we create a new file named `NetworkService.swift`:

```swift
enum NetworkService {
    case zen
    case showUser(id: Int)
    case createUser(firstName: String, lastName: String)
    case updateUser(id: Int, firstName: String, lastName: String)
    case showAccounts
}
```

This enum is used to make sure that you provide implementation details for each
target (at compile time). You can see that parameters needed for requests can be defined as per the enum cases parameters. The enum *must* additionally conform to the `SteeringRequest` protocol. Let's get this done via an extension in the same file:

```swift
// MARK: - SteeringRequest Protocol Implementation
extension NetworkService: SteeringRequest {
    var baseURL: URL { URL(string: "https://somebaseurl.com/api")! }

    var method: SteeringRequestMethod {
        switch self {
        case .zen:
            return .get
        case .showUser:
            return .get
        case .createUser:
            return .post
        case .updateUser:
            return .put
        case .showAccounts:
            return .get
        }
    }

    var path: String {
        switch self {
        case .zen:
            return "/zen"
        case .showUser(let id):
            return "/user\(id)"
        case .createUser:
            return "/user"
        case .updateUser(let id):
            return "/user\(id)"
        case .showAccounts:
            return "/accounts"
        }
    }

    var parameters: [String : String]? { ["key": "SOME_API_KEY"] }

    var headers: [String : String]? { ["Authorization": "Bearer SOME_JWT_TOKEN"] }

    var body: SteeringRequestBody {
        switch self {
        case .zen:
            return .none
        case .showUser:
            return .none
        case .createUser(let firstName, let lastName):
            let newUser = NewUser(firstName: firstName,
                                  lastName: lastName)

            return .jsonEncodable(newUser,
                                  jsonEncoder: JSONEncoder())
        case .updateUser(let id, let firstName, let lastName):
            let user = User(id: id,
                            firstName: firstName,
                            lastName: lastName)

            return .jsonEncodable(user,
                                  jsonEncoder: .init())
        case .showAccounts:
            return .none
        }
    }

    var validation: SteeringRequestValidation {
        switch self {
        case .zen:
            return .successCodes
        case .showUser:
            return .successAndRedirectCodes
        case .createUser:
            return .customCodes([200, 204, 300])
        case .updateUser:
            return .none
        case .showAccounts:
            return .successCodes
        }
    }
}
```

You can see that the `SteeringRequest` protocol makes sure that each value of the enum translates into a full request. Each full request is split up into the `baseURL`, the `path` specifying the subpath of the request, the `method` which defines the HTTP method and `parameters`, `headers`, and `body` with directly map to the request.

To begin utilizing this networking layer you need to construct an instance of the `Steering` provider. Ensure you maintain a reference to the provider, otherwise it will be automatically released and a response may never be received.

```swift
final class Networking {

    /// The service provider instance.
    let provider = Steering<NetworkService>()
}
```

Note that at this point you have added enough information for a basic API networking layer to work.
By default `Steering` will combine all the given parts into a full request:

```swift
extension Networking {
    func showUser(with id: Int) { 
        provider.request(User.self, with: .init(), from: .showUser(id: id)) { result in
            switch result {
            case .success(let user):

                // The fully-parsed `User` is returned from the network request.
                _ = user.id
                _ = user.firstName
                _ = user.lastName

            case .failure(let error):

                // An explicit error enum is returned describing exactly what went wrong.
                switch error {
                case .service(let error):
                    _ = error
                case .parsing(let error):
                    _ = error
                case .validation(let statusCode):
                    _ = statusCode
                }
            }
        }
    }
}
```
