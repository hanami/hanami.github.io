---
title: Meet Tim and Sean
date: 2025-06-26 18:15:00 UTC
tags: announcements
author: Tim Riley
image: true
excerpt: >
  It’s week 4 of our sponsorship drive. Get to know the people you’re supporting.
---

It’s week 4 of our [sponsorship drive](/blog/2025/06/03/become-a-hanami-dry-and-rom-patron/)! This week is your chance to get to know the people you’ll be supporting:

![Sean and Tim at RubyConf 2024](/blog/2025/06/26/meet-tim-and-sean/sean-and-tim.jpeg "Sean and Tim at RubyConf 2024")

That’s Sean on the left, me on the right. Now let’s get into it!

## Meet Tim

### Tell us a bit about yourself

I’m a software developer living in Canberra, Australia with my wife and two children.

I’ve been toying with computers since I was a kid. After years of playing newsagency-bought shareware games, teenage me found Linux (thank you [APC Mag Pocketbook](https://archive.org/details/TheLinuxPocketbook/TheLinuxPocketbookfrontCover.jpg)). After another  few years, mostly spent reinstalling distros and theming Openbox, I eventually found Ruby! That was in 2002. I’ve been lucky to work with it ever since.

### What’s your story with Hanami?

My path towards Hanami started 10 years ago. Back then I was helping to run [Icelab](https://www.icelab.com.au), a design and development agency here in Australia. Our team would build apps for our clients in their entirety, and go on to maintain them thereafter. Our tool of choice was Rails, and it had served us well.

After shipping and maintaining dozens of Rails apps over the years, I felt like I had begun to stagnate as a developer. I was no longer growing and learning in the way I wanted to. The code I’d been writing no longer felt right for me.

I knew I needed some kind of change to break out of the rut and begin a new stage of growth. But I loved Ruby, and didn’t want to leave. So instead I looked around for people who were doing things *differently* with Ruby. I found [Roda](https://roda.jeremyevans.net) from [Jeremy Evans](https://github.com/jeremyevans). I found [Peter Solnica](https://github.com/solnic). It was this that set me off on my journey to Hanami.

In 2015, I was part of the team that founded the [Dry](https://dry-rb.org) project. I spent the following years building production apps at Icelab composed of Dry, [Rom](https://rom-rb.org), and Roda. This was exactly the experience I hoped for!  We built great things, and I learnt so much along the way.

A few years later, the Dry and Hanami teams joined together to build the next version of Hanami. This is where I’ve focused my energy since. I drove most of the development towards [2.0](https://hanamirb.org/blog/2022/11/22/announcing-hanami-200/), [2.1](https://hanamirb.org/blog/2024/02/27/hanami-210/) and [2.2](https://hanamirb.org/blog/2024/11/05/hanami-220/).

I’m very proud of the experience we’ve created with Hanami. We provide essential diversity to the Ruby community. Today, anyone who reaches that same moment of _needing something different_ doesn’t need to feel like they’re in the wilderness, and possibly leave Ruby entirely. They now have an easy step to take: `gem install hanami`. Within minutes they can be playing and learning.

### What are you looking forward to for the future?

I’m excited to set Hanami up for a successful second decade! We’ve spent years preparing a good foundation with version 2. Now we get to build upon it.

In the near term, this means making [these goals](https://hanamirb.org/blog/2024/12/10/state-of-hanami-december-2024/) happen: unify Hanami, Dry and Rom, help our users be more successful, and fundraise for sustainable maintenance. You’ve already seen the launch of our fundraising, and we’re already making big strides towards the others. I can’t wait to share more later this year.

Together, these efforts will help us find our critical mass, across all parts of our community: users, contributors, and financial supporters. And the more people we bring together, the more their ideas and passion can help make Hanami (and Dry and Rom) better for everyone, all while having fun and learning along the way!

Looking a little further ahead, there are a couple of other bits I’m particularly excited to drive: a first-class extensions API for Hanami, and the establishment of a clear and trustworthy governance structure for our projects.

There’s lots to do, and it’s occasionally overwhelming, but I’m happy to be here. The future is bright!

## Meet Sean

### Tell us a bit about yourself

I’m an [independent contractor](https://seancollins.tech/) who lives in Denver, Colorado. I’ve been working with Ruby for over a dozen years. I’ve also done some purely functional programming with Elm. I’m interested in pragmatic software architecture, helping codebases stay healthy as they grow.

### What’s your story with Hanami

I moved to Colorado in 2015 and the timing was auspicious: Rocky Mountain Ruby took place shortly after I arrived. On the first day, I participated in a workshop about “Component-Based Rails Applications”, which used Rails Engines to split up large codebases. This was novel to me, managing scope and thinking about your dependencies from a higher level. I tried that approach on a couple projects but it was difficult: I was constantly fighting against the framework, and few gems supported Engines because they were used so rarely.

A couple months later, at the Boulder Ruby meetup, a speaker mentioned a new Ruby web framework called “Lotus.” It supported modularity as a first-class feature. Beyond that, it broke things into more layers than Rails did, and encouraged writing small classes with limited responsibilities. This was exactly what I had been looking for! A more measured approach to writing large Ruby apps.

I started contributing to the project: first documentation fixes, then with a generator. It was later renamed to Hanami and I joined the core team for the 1.0 launch. My level of involvement has fluctuated over the years, but I've been more involved again since early last year. I'm excited and energized by the community interest increasing as we are promoting [our sponsorship drive](https://sponsor.hanamirb.org/)!

### What are you looking forward to for the future?

I'm excited about the potential that AI-assisted development holds for Hanami. I know this is controversial but I really think AI can help speed up Hanami’s adoption and reduce much of the friction users have faced in the past.

In particular, AI can help us address some of the framework’s current challenges, while also amplifying its architectural strengths.

Challenges, mitigated by AI:

* Smaller knowledge base. There’s less information available on the web about Hanami than Rails: complete apps, blog posts, Stack Overflow questions, and more. This means there’s less training data available for LLMs to be aware of Hanami. However, Hanami’s simple APIs and more modular architecture means documentation and source code can be brought into the LLMs context window. That means you can ask questions and get tailored answers that apply to your specific project. That said, hallucinations are still a real concern, so AI isn’t a substitute for understanding the framework yourself. At best, it’s an accelerant and can help you find the documentation you need.
* Fewer third-party gems. Hanami has a smaller ecosystem of ready-made gems compared to Rails. Over the years, I’ve heard this as a sticking point for why people have trouble succeeding with Hanami. Now in the age of AI, many people are generating the code they used to pull in as a dependency, in the style that matches the rest of their codebase. You can generate bespoke code that you can bring into your codebase (after you review it!!) instead of adding a dependency.
* More boilerplate. Hanami encourages writing classes that are small, with a tight scope of responsibility. This means Hanami projects have more files and more code, requiring switching between files more. When you’re the one typing everything out, this can be annoying. When AI is writing and modifying the code, this is less of an issue.

Advantages in the AI era:

* Functional, immutable style. Hanami enables and encourages a more functional and immutable style of writing Ruby. Instead of internal state determining behavior, code’s flow can often be inferred lexically, which makes it easier for LLMs (and humans) to reason about.
* Modularity with Slices. The framework’s architectural boundaries (via Slices) reduce cross-cutting concerns, making it easier for different humans and AI agents to work in parallel without unintended side effects. Agents can be made to ignore everything but the Slice they’re working on (and its dependencies), to keep them focused on the code that matters.
* Explicitness and structure. Hanami leans towards being explicit, instead of adding a lot of implicit ‘magic’ behind-the-scenes. This is similar to Python and Django, which LLMs tend to perform well with. That explicitness pays dividends in both AI-generated and human-reviewed code. It also has a cost, with more lines of code, but when those lines are written by the computer, they’re less costly to write (though still need to be reviewed carefully).
* Scalability of complexity. As individual developers become more productive with AI, the ability to manage complexity becomes more important. If developers start reliably writing 10 times more code, then codebases will naturally grow much faster. Hanami’s modularity and built-in tools for architecting large codebases will be invaluable in those situations.

Looking ahead, I also see opportunities where we can leverage AI to help us audit, fix, and maintain our documentation. This could free us up to work on other activities, and increase the quality of our documentation.

To be clear: we’re not at the point where AI agents can write Hanami apps as well as they can write Rails apps. Rails has been more exposed to the world, so LLMs have “seen” it more. But I believe we can close that gap to make Hanami a fully viable alternative to Rails. Beyond that, I can imagine a future where Hanami’s modularity, explicitness, and functional/immutable style help it become the preferred framework for writing Ruby apps.

## Sponsorship updates

(What is all of this? [Read our sponsorhip site to learn more.](https://sponsor.hanamirb.org))

Since [week 3](/blog/2025/06/20/field-report-from-riga-and-the-rooftop/), we’ve had one new person become a community patron and support our work on Hanami, Dry and Rom. Thank you very much, [Mathew Button](https://github.com/mathewdbutton)!

Bit by bit, we get closer. If you’re a human being who cares about a diverse, thriving Ruby, we’d love for you to join Matthew and [all our community patrons](https://github.com/sponsors/hanami). And if you’re a collection of human beings in a business, we’d love to hear from you too!

As of this week, we’re still sitting at $27.5k:

🟩 🟩 🟩 🟩 ⬜ ⬜ ⬜ ⬜ ⬜ ⬜<br>
_**$27.5k of $70k** — 39% to our goal…_

Next week, I think it’s time I address the 800-pound elephant in the room. I’ll see you then.
