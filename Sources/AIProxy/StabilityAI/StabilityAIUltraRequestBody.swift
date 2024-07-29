//
//  StabilityAIUltraRequestBody.swift
//
//
//  Created by Lou Zell on 7/29/24.
//

// The models below are derived from this reference:
// https://platform.stability.ai/docs/api-reference#tag/Generate/paths/~1v2beta~1stable-image~1generate~1ultra/post
public struct StabilityAIUltraRequestBody: MultipartFormEncodable {

    // Required

    /// What you wish to see in the output image. A strong, descriptive prompt that clearly
    /// defines elements, colors, and subjects will lead to better results.
    ///
    /// To control the weight of a given word use the format `(word:weight)`, where `word` is
    /// the word you'd like to control the weight of and `weight` is a value between 0 and 1.
    /// For example: `The sky was a crisp (blue:0.3) and (green:0.8)` would convey a sky that
    /// was blue and green, but more green than blue.
    public let prompt: String

    // Optional
    /// Controls the aspect ratio of the generated image.
    /// Default: "1:1"
    /// Possible values: "16:9", "1:1", "21:9", "2:3", "3:2", "4:5", "5:4", "9:16", "9:21"
    public let aspectRatio: String?

    /// A blurb of text describing what you do not wish to see in the output image.
    /// This is an advanced feature.
    public let negativePrompt: String?

    /// Dictates the `content-type` of the generated image
    /// Defaults to `png`
    public let outputFormat: StabilityAIUltraOutputFormat?

    /// A specific value that is used to guide the 'randomness' of the generation. (Omit this
    /// parameter or pass `0` to use a random seed.)
    /// Possible values: `[ 0 .. 4294967294 ]`
    public let seed: Int?


    var formFields: [FormField] {
        return [
            .textField(name: "prompt", content: self.prompt),
            self.aspectRatio.flatMap { .textField(name: "aspect_ratio", content: $0) },
            self.negativePrompt.flatMap { .textField(name: "negative_prompt", content: $0) },
            self.outputFormat.flatMap { .textField(name: "output_format", content: $0.rawValue) },
            self.seed.flatMap { .textField(name: "seed", content: String($0))},
        ].compactMap { $0 }
    }


    // This memberwise initializer is autogenerated.
    // To regenerate, use `cmd-shift-a` > Generate Memberwise Initializer
    // To format, place the cursor in the initializer's parameter list and use `ctrl-m`
    public init(
        prompt: String,
        aspectRatio: String? = nil,
        negativePrompt: String? = nil,
        outputFormat: StabilityAIUltraOutputFormat? = nil,
        seed: Int? = nil
    ) {
        self.prompt = prompt
        self.aspectRatio = aspectRatio
        self.negativePrompt = negativePrompt
        self.outputFormat = outputFormat
        self.seed = seed
    }
}

public enum StabilityAIUltraOutputFormat: String {
    case jpeg
    case png
    case webp
}