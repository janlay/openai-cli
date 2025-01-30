# openai-cli
A universal cli for OpenAI, written in BASH.

# Features
- [x] Scalable architecture allows for continuous support of new APIs.
- [x] Custom API name, version, and all relevant properties.
- [x] Dry-run mode (without actually initiating API calls) to facilitate debugging of APIs and save costs.
- [x] New in v3: Supports any AI services that provide OpenAI-compatible APIs.

Important changes in version 3:
- `-v api_version` in previous versions is now removed. If you have a custom `OPENAI_API_ENDPOINT`, you need to append API version in it. The internal API version is remove as some services like DeepSeek don't have version prefix in `/v1/chat/completions`.
- `OPENAI_CHAT_MODEL` no longer supported, use `OPENAI_API_MODEL` instead.
- By default, the request no longer includes optional parameters `temperature` / `max_tokens`. You need to explictly add `+temperature` / `+max_tokens` to customize if necessary.

Available APIs:
- [x] `chat/completions` (default API)
- [x] `models`
- [x] `images/generations`
- [x] `embeddings`
- [x] `moderations`

The default API `chat/completions` provides:
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

  Also install the manual page, e.g.:
  ```bash
  pandoc -s -f markdown -t man README.md > /usr/local/man/man1/openai.1
  ```
  <details>
  <summary>Further reading: curl's killer feature</summary>
  <a href="https://daniel.haxx.se/blog/2020/09/10/store-the-curl-output-over-there/"><code>-OJ</code> is a killer feature</a>
  </details>

Now you can try it out!

# Tips
## Getting started
To begin, type `openai -h` to access the help manual.

⚠️ If you run `openai` directly, it may appear to be stuck because it expects prompt content from stdin which is not yet available. To exit, simply press Ctrl+C to interrupt the process.

<details>
  <summary>Why are you so serious?</summary>
  
What happens when the `openai` command is executed without any parameters? It means that:
- The default API used will be `chat/completions`, and the schema version will be `v1`.
- The prompt will be read from stdin.
- The program will wait for input while stdin remains empty.
</details>

## Quick Examples
The best way to understand how to use `openai` is to see various usage cases.
- Debug API data for testing purposes  
  `openai -n foo bar`
- Say hello to OpenAI  
  `openai Hello`
- Use another model  
  `openai +model=gpt-3.5-turbo-0301 Hello`
- Disable streaming, allow for more variation in answer  
  `openai +stream=false +temperature=1.1 Hello`
- Call another available API  
  `openai -a models`
- Create a topic named `en2fr` with initial prompt  
  `openai @en2fr Translate to French`
- Use existing topic  
  `openai @en2fr Hello, world!`
- Read prompt from clipboard then send result to another topic  
  `pbpaste | openai | openai @en2fr`

## Providing prompt
There are multiple ways to obtain a prompt using `openai`:
- Enclose the prompt in single quotes `'` or double quotes `"`  
  `openai "Please help me translate '你好' into English"`
- Use any argument that does not begin with a minus sign `-`  
  `openai Hello, world!`
- Place any arguments after `--`  
  `openai -n -- What is the purpose of the -- argument in Linux commands`
- Input from stdin  
  `echo 'Hello, world!' | openai`
- Specify a file path with `-f /path/to/file`  
  `openai -f question.txt`
- Use `-f-` for input from stdin  
  `cat question.txt | openai -f-`

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

Environment variables can also be set in `$HOME/.openai/config`.

## Working with compatible AI services
You can set the environment variable `OPENAI_COMPATIBLE_PROVIDER` to another service name in uppercase, such as `DEEPSEEK`. Then set the three environment variables `DEEPSEEK_API_ENDPOINT`, `DEEPSEEK_API_KEY`, and `DEEPSEEK_API_MODEL` respectively:
```bash
export OPENAI_COMPATIBLE_PROVIDER=DEEPSEEK
export DEEPSEEK_API_ENDPOINT=https://api.deepseek.com
export DEEPSEEK_API_KEY=sk-***
export DEEPSEEK_API_MODEL=deepseek-chat
```

You may have noticed that if you set `OPENAI_COMPATIBLE_PROVIDER` to `FOO`, you also need to set `FOO_API_ENDPOINT`, `FOO_API_KEY`, and `FOO_API_MODEL` accordingly.

After gathering information on multiple AI providers, you can switch the AI service by setting a temporary environment variable, `OPENAI_COMPATIBLE_PROVIDER`, as shown below:
```bash
# Switch to DeepSeek
OPENAI_COMPATIBLE_PROVIDER=DEEPSEEK openai
# Switch to Qwen
OPENAI_COMPATIBLE_PROVIDER=QWEN openai
# Switch to the default provider (OpenAI)
OPENAI_COMPATIBLE_PROVIDER= openai
```

## Testing your API invocations
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
