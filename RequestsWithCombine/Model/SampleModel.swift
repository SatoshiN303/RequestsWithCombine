//
//  SampleModel.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/19.
//

import Foundation
import Combine
import APIKit

class SampleModel: ObservableObject {
    
    @Published var items: [Repository] = []
    
    let didChange = PassthroughSubject<Void, Never>()
    private var cancellable: AnyCancellable?
    var requestCancellable: Cancellable?
    
    init() {
        cancellable = didChange
            .debounce(for: 1.0, scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.chainingFetch() // 直列
//                self?.parallelFetch() // 並列
        }
    }
    
    var searchText: String = "" {
        didSet { didChange.send(()) }
    }
    
    func cancel() {
        self.requestCancellable?.cancel()
        self.requestCancellable = nil
    }
    
}

private extension SampleModel {
        
    func chainingFetch() {
        debugPrint("chainingFetch")
        executeChainingRequestWithPublisher()
        //executeChainingRequestWithFuture()
    }
    
    func parallelFetch() {
        executeParallelRequestWithPublisher()
    }
    
    // MARK: - Private 
    
    /* APIKit.RequestにPublisherを生やして直列で
     * search/repositories のレスポンスで repos/{owner}/{repositry} を叩いてみるサンプル
     */
    private func executeChainingRequestWithPublisher() {
        let searchRepositories = SearchRepositoriesRequest(query: searchText).publisher.eraseToAnyPublisher()
        self.requestCancellable = searchRepositories
            .compactMap { $0.items.first }
            .flatMap { (repository) -> AnyPublisher<GetRepositoyRequest.Response, Error> in
                GetRepositoyRequest(owner: repository.owner.login, repositry: repository.name).publisher.eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { (completion) in
                switch completion {
                case .finished:
                    debugPrint("request finished")
                case let .failure(error):
                    debugPrint("request failed : \(error)")
                }
            } receiveValue: { [weak self] repository in
                self?.items = [repository]
            }
    }
        
    /* Futureを利用して直列で
     * search/repositories のレスポンスで repos/{owner}/{repositry} を叩いてみるサンプル
     */
    private func executeChainingRequestWithFuture() {
        self.requestCancellable = fetchRepos(query: searchText)
            .compactMap { $0.items.first }
            .flatMap { [unowned self] repository in
                self.fetchRepository(owner: repository.owner.login, repo: repository.name)
            }.sink { (completion) in
                switch completion {
                case .finished:
                    debugPrint("request finished")
                case let .failure(error):
                    debugPrint("request failed : \(error)")
                }
            } receiveValue: { [weak self] repository in
                self?.items = [repository]
            }
    }
    
    /* APIKit.RequestにPublisherを生やして並列で
     * /search/repositories と /search/users を叩いてみるサンプル
     */
    private func executeParallelRequestWithPublisher() {
        let searchRepositories = SearchRepositoriesRequest(query: searchText).publisher.eraseToAnyPublisher()
        let searchUsers = SearchUsersRequest(query: searchText).publisher.eraseToAnyPublisher()
        self.requestCancellable = Publishers.Zip(searchRepositories, searchUsers)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: { (repos, users) in
                print(repos)
                print(users)
            }
    }
    
    // ※Futrureは即時実行される => インスタンスが生成されたタイミングでSubscribeをしなくても処理が走る
    private func fetchRepos(query: String) -> Future<SearchRepositoriesRequest.Response, Error> {
        return Future<SearchRepositoriesRequest.Response, Error> { promise in
            Session.send(SearchRepositoriesRequest(query: query), callbackQueue: .main) { (result) in
                switch result {
                case .success(let res):
                    // 処理成功
                    promise(.success(res))
                case .failure(let error):
                    // 処理失敗
                    promise(.failure(error))
                }
            }
        }
    }
    
    // ※Futrureは即時実行される => インスタンスが生成されたタイミングでSubscribeをしなくても処理が走る
    private func fetchRepository(owner: String, repo: String) -> Future<GetRepositoyRequest.Response, Error> {
        return Future<GetRepositoyRequest.Response, Error> { promise in
            Session.send(GetRepositoyRequest(owner: owner, repositry: repo), callbackQueue: .main) { (result) in
                switch result {
                case .success(let res):
                    // 処理成功
                    promise(.success(res))
                case .failure(let error):
                    // 処理失敗
                    promise(.failure(error))
                }
            }
        }
    }
        
}

