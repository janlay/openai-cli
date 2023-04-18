# openai-cli
A universal cli for OpenAI, written in BASH.

# Features
- [x] Scalable architecture allows for continuous support of new APIs.
- [x] Custom API name, version, and related parameters.
- [x] Dry-run mode (without actually initiating API calls) to facilitate debugging of APIs and save costs.

The main API `chat/completions` provides:
  - [x] Complete pipelining to interoperate with other applications
  - [x] Allow prompts to be read from command line arguments, file, and stdin
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
  curl -fsSLOJ https://go.janlay.com/openai
  chmod +x openai
  ```
  You may want to add this file to a directory in `$PATH`. 
  <details>
  <summary>Further reading: curl's killer feature</summary>
  [-OJ is a killer feature](https://daniel.haxx.se/blog/2020/09/10/store-the-curl-output-over-there/)
  </details>

Now you can try it out!

# Tips
## Getting started
To begin, type `openai -h` to access the help manual.

⚠️ If you run `openai` directly, it may appear to be stuck because it expects prompt content from stdin which is not yet available. To exit, simply press Ctrl+C to interrupt the process.

## Why are you so serious?
What happens when the `openai` command is executed without any parameters? It means that:
- The default API used will be `chat/completions`, and the schema version will be `v1`.
- The prompt will be read from stdin.
- The program will wait for input while stdin remains empty.

## Providing prompt
There are multiple ways to obtain a prompt using `openai`:
- Enclose the prompt in single quotes `'` or double quotes `"`
- Use any argument that does not begin with a minus sign `-`
- Place any arguments after `--`
- Input from stdin
- Specify a file path with `-f /path/to/file`
- Use `-f-` for input from stdin

Choose any one you like :-)

## OpenAI key
`$OPENAI_API_KEY` must be available to use this tool. Prepare your OpenAI key in `~/.profile` file by adding this line:
```bash
export OPENAI_API_KEY=sk-****
```
Or you may want to run with a temporary key for one-time use:
```bash
OPENAI_API_KEY=sk-**** openai hello
```

## Testing your API invocation
`openai` offers a [dry-run mode](https://en.wikipedia.org/wiki/Dry_run) that allows you to test command composition without incurring any costs. Give it a try!

```bash
openai -n hello, world!

# This would be same:
openai -n 'hello, world!'
```

<details>
<summary>Command and output</summary>

```
$ openai -n hello, world!
Dry-run mode, no API calls made.

Request URL:
--------------
https://api.openai.com/v1/chat/completions

Authorization:
--------------
Bearer sk-cfw****NYre

Payload:
--------------
{
  "model": "gpt-3.5-turbo",
  "temperature": 0.5,
  "max_tokens": 200,
  "stream": true,
  "messages": [
    {
      "role": "user",
      "content": "hello, world!"
    }
  ]
}
```
</details>
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

<details>
<summary>Command and output</summary>

```
 $ openai hello, world!
Hello there! How can I assist you today?
```

</details>

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

# LICENSE
This project uses the MIT license. Please see [LICENSE](https://github.com/janlay/openai-cli/blob/master/LICENSE) for more information.
