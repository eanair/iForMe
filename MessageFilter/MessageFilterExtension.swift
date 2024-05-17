import IdentityLookup

final class MessageFilterExtension: ILMessageFilterExtension {}

extension MessageFilterExtension: ILMessageFilterQueryHandling, ILMessageFilterCapabilitiesQueryHandling {
  func handle(_: ILMessageFilterCapabilitiesQueryRequest, context _: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterCapabilitiesQueryResponse) -> Void) {
    let response = ILMessageFilterCapabilitiesQueryResponse()

    completion(response)
  }

  func handle(_ queryRequest: ILMessageFilterQueryRequest, context: ILMessageFilterExtensionContext, completion: @escaping (ILMessageFilterQueryResponse) -> Void) {
    let (offlineAction, offlineSubAction) = self.offlineAction(for: queryRequest)

    switch offlineAction {
    case .allow, .junk, .promotion, .transaction:
      let response = ILMessageFilterQueryResponse()
      response.action = offlineAction
      response.subAction = offlineSubAction

      completion(response)

    case .none:
      context.deferQueryRequestToNetwork { networkResponse, error in
        let response = ILMessageFilterQueryResponse()
        response.action = .none
        response.subAction = .none

        if let networkResponse = networkResponse {
          (response.action, response.subAction) = self.networkAction(for: networkResponse)
        } else {
          NSLog("Error deferring query request to network: \(String(describing: error))")
        }

        completion(response)
      }

    @unknown default:
      break
    }
  }

  private func offlineAction(for queryRequest: ILMessageFilterQueryRequest) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
    guard let sender = queryRequest.sender else {
      return (.none, .none)
    }

    let spamNumbers = UserDefaults.standard.stringArray(forKey: "SpamNumbers") ?? []

    if spamNumbers.contains(sender) {
      return (.junk, .none)
    } else {
      return (.allow, .none)
    }
  }

  private func networkAction(for _: ILNetworkResponse) -> (ILMessageFilterAction, ILMessageFilterSubAction) {
    return (.allow, .none)
  }
}
