//
//  OpenAIChatCompletionResponseBody.swift
//
//
//  Created by Lou Zell on 8/17/24.
//

import Foundation

public struct OpenAIChatCompletionResponseBody: Decodable {
    /// A list of chat completion choices.
    /// Can be more than one if `n` on `OpenAIChatCompletionRequestBody` is greater than 1.
    public let choices: [OpenAIChatChoice]

    /// The Unix timestamp (in seconds) of when the chat completion was created.
    public let created: Int

    /// The model used for the chat completion.
    public let model: String

    /// This fingerprint represents the backend configuration that the model runs with.
    /// Can be used in conjunction with the `seed` request parameter to understand when
    /// backend changes have been made that might impact determinism.
    /// Add in https://github.com/lzell/aiproxy/issues/592
    // public let systemFingerprint: String?
}

public struct OpenAIChatChoice: Decodable {
    /// The reason the model stopped generating tokens. This will be `stop` if the model hit a
    /// natural stop point or a provided stop sequence, `length` if the maximum number of
    /// tokens specified in the request was reached, `content_filter` if content was omitted
    /// due to a flag from our content filters, `tool_calls` if the model called a tool, or
    /// `function_call` (deprecated) if the model called a function.
    public let finishReason: String?

    /// A chat completion message generated by the model.
    public let message: OpenAIChoiceMessage

    private enum CodingKeys: String, CodingKey {
        case finishReason = "finish_reason"
        case message
    }
}

public struct OpenAIChoiceMessage: Decodable {
    /// The contents of the message.
    public let content: String?

    /// The role of the author of this message.
    public let role: String

    /// The tool calls generated by the model, such as function calls.
    public let toolCalls: [OpenAIToolCall]?

    private enum CodingKeys: String, CodingKey {
        case content
        case role
        case toolCalls = "tool_calls"
    }
}

public struct OpenAIToolCall: Decodable {
    /// The type of the tool. Currently, only `function` is supported.
    public let type: String

    /// The function that the model instructs us to call
    public let function: OpenAIFunction
}

public struct OpenAIFunction: Decodable {
    /// The name of the function to call.
    public let name: String

    /// The arguments to call the function with, as generated by the model in JSON format. Note
    /// that the model does not always generate valid JSON, and may hallucinate parameters not
    /// defined by your function schema. Validate the arguments in your code before calling
    /// your function.
    ///
    /// Implementor's note: I no longer think the above warning is true, now that this launched:
    /// https://openai.com/index/introducing-structured-outputs-in-the-api/
    public let arguments: [String: Any]?

    private enum CodingKeys: CodingKey {
        case name
        case arguments
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        if let argumentsRaw = try? container.decode(String.self, forKey: .arguments),
           let argumentsData = argumentsRaw.data(using: .utf8) {
            self.arguments = try JSONSerialization.jsonObject(with: argumentsData, options: []) as? [String: Any]
        } else{
            self.arguments = nil
        }
    }
}