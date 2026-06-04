
## **PSConfEU Lightning Talk: AI, Argument Completers, and First-Time Contributions**

Hi everyone, my name is Paul Naughton. I'm from Galway in the West of Ireland, and this is my very first PSConfEU!

It's been an incredible experience so far, my thanks to all speakers, sponsors, and organisers on an amazing job.

One of my main goals coming here was to dive deeper into Pester testing. I attended Jakub Jares Tuesday session and asked a question about how to unit test custom **Argument Completers** using **Pester**. I've already had some offers of assistance from the sponsor community on that, so thank you sponsors!

I'm a fan of Argument Completers. Alongside Pester, they are one of the most powerful tools we have for tool-making and for building a great user experience.

I recently put this passion to work for my very first open-source contribution. I contributed to Doug Finke's **`PSAISuite`** module. The module provides a clean chat interface to various AI backends (needs API keys). PSAISuite allows teams to swap, test, and benchmark responses across 15+ providers without modifying core application logic.

When I started, it supported 13 providers; I've since bumped that up to **15 providers**, and I aim to contribute some more.

Crucially, I enhanced the **Argument Completers** for selecting these providers and their models.

My best part?
It now surfaces the detailed model description data returned by the `List Models` endpoints per provider. This is metadata that you usually never see unless you inspect the raw response. Now, when you tab through models like Fireworks, POE, or Anthropic at the command line, you get tooltips with full descriptions to help you choose the model on the fly.

Let's jump into a quick demo of how it looks in action, followed by a brief look at the code behind it.
