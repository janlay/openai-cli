# openai-cli
A universal cli for OpenAI, written in BASH.

# Features
- [x] Scalable architecture allows for continuous support of new APIs.
- [x] Custom API name, version, and related parameters.
- [x] Dry-run mode (without actually initiating API calls) to facilitate debugging of APIs and save costs.
- Features related to `chat/completions`:

      - [x] Complete pipelining to interoperate with other applications
      - [x] Allow prompts to be read from command line arguments, files, and standard input
      - [x] Support streaming
      - [x] Support multiple topics
      - [x] Support continuous conversations.
      - [ ] Token usage

# Installation
- [jq](https://stedolan.github.io/jq/) is required.
  - Linux: `sudo apt install jq`
  - macOS: `brew install jq`
- Download script and mark it executable:
  ```bash
  curl -fsSLOJ https://raw.githubusercontent.com/janlay/openai-cli/master/openai
  chmod +x openai
  ```
  You may want to add this file to a directory in `$PATH`. 

Now you can try it out!

# Tips
## Getting started
First of all, run `openai -h` to grab help.

⚠️ If you run `openai` directly, it appears to be stuck. This is because `openai` expects to receive prompt content from stdin, but the stdin has no content available yet. Just press Ctrl+C to interrupt and exit.

## OpenAI key
`$OPENAI_API_KEY` must be available to use this tool. Prepare your OpenAI key in `~/.profile` file by adding this line:
```bash
export OPENAI_API_KEY=sk-****
```
Or you may want to run with a temporary key for one-time use:
```bash
OPENAI_API_KEY=sk-**** openai hello
```

## Testing your API invokation
`openai` offers a [dry-run mode](https://en.wikipedia.org/wiki/Dry_run) that allows you to test command composition without incurring any costs. Give it a try!
```bash
openai -n hello, world!

# This would be same:
openai -n 'hello, world!'
```

With full pipelining support, you can achieve the same functionality using alternative methods:
```bash
echo 'hello, world!' | openai -n
```
<details>
<summary>For BASH gurus</summary>

This would be same:
```bash
echo 'hello, world!' >hello.txt
openai -n <hello.txt
```

Even this one:
```bash
openai -n <<<'hello, world!'
```

and this:
```bash
openai -n <<(echo 'hello, world!')
```
</details>

It seems you have understood the basic usage. Try to get real answer from OpenAI:
```bash
openai hello, world!
```

## Topics
Topic starts with a `@` sign. so `openai @translate Hello, world!` means calling the specified topic `translate`.

To create new topic, like translate, with the initial prompt (system role, internally):
```bash
openai @translate 'Translate, no other words: Chinese -> English, Non-Chinese -> Chinese'
```

Then you can use the topic by
```bash
openai @translate 'Hello, world!'
```
You should get answer like `你好，世界！`.

Again, to see what happens, use the dry-run mode by adding `-n`. You will see the payload would be sent:
```json
{
  "model": "gpt-3.5-turbo",
  "temperature": 0.5,
  "max_tokens": 200,
  "stream": true,
  "messages": [
    {
      "role": "system",
      "content": "Translate, no other words: Chinese -> English, Non-Chinese -> Chinese"
    },
    {
      "role": "user",
      "content": "Hello, world!"
    }
  ]
}
```

## Chatting
All use cases above are standalone queries, not converstaions. To chat with OpenAI, use `-c`. This can also continue existing topic conversation by prepending `@topic`.

Please note that chat requests will quickly consume tokens, leading to increased costs.

## Advanced
To be continued.

## Manual
To be continued.
