//
//  APIPublisher.swift
//  RequestsWithCombine
//
//  Created by 佐藤 慎 on 2021/01/19.
//
//  参考: SwiftUI + Combine + APIKitでインクリメンタルサーチ
//  https://bit.ly/3o5xLPH
//

import Foundation
import APIKit
import Combine

struct APIPublisher<R: APIKit.Request>: Publisher where R.Response: Decodable {
    
    typealias Output = R.Response // 処理成功時の型
    typealias Failure = Error     // 処理失敗時の型

    let request: R  //APIリクエスト
    let callbackQueue: CallbackQueue = .main //通信処理のCallbackで呼ばれるスレッド

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        
        // 通信処理を行う
        let task = Session.send(request, callbackQueue: callbackQueue) { result in
            switch result {
            case .success(let res):
                // 処理成功
                let _ = subscriber.receive(res)
                subscriber.receive(completion: .finished)
            case .failure(let error):
                // 処理失敗
                subscriber.receive(completion: .failure(error))
            }
        }

        // 登録完了を通知
        // 通信をキャンセルできるようにtaskを渡す
        let subscription = APISubscription(combineIdentifier: CombineIdentifier(), task: task)
        subscriber.receive(subscription: subscription)
    }
}

struct APISubscription: Subscription {

    let combineIdentifier: CombineIdentifier
    // APIPublisherから通信に使ったインスタンスをもらって保持する
    let task: APIKit.SessionTask?

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {
        // 通信をキャンセルする
        self.task?.cancel()
    }
}
