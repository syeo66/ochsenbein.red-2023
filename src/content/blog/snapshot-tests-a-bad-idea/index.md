---
title: 'Why do I think snapshot tests are a bad idea?'
date: '2022-07-20T15:01:00.000Z'
description: 'Discussing snapshot tests and why I think they are a bad idea. And what you should do instead.'
devTo: 'https://dev.to/syeo66/why-do-i-think-snapshot-tests-are-a-bad-idea-1imp'
---
When testing your code you'll come across a lot of different problems to solve. Unfortunately, an application does usually not work with strictly pure functions and without any side effects at all. So we have to mock stuff, or simulate environments, inject dependencies and a bunch of other things. If you've ever worked on the frontend side and tried to write tests you will have noticed that it is particularly hard to test components. One possible solution are [snapshot tests](https://jestjs.io/docs/snapshot-testing).

## What is snapshot testing?

The idea of snapshot testing is pretty simple. You create your component and take a snapshot if you're done. From now on the test will fail when it detects any change in the output of the component. In those cases you have two possible solutions: Fix the component to behave as before or create a new snapshot.

## What is wrong with snapshot testing?

Well, it sounds intriguing, does it not? But there are some problems with snapshot testing.

First of all, snapshot testing assumes the component was doing the right thing when the snapshot was taken. This might lead to a false sense of security. Also, snapshot tests do not say anything about the expected behaviour of a component. It's just a simple "It does what it did before".

And then you'd have to think about what should happen if s snapshot test fails in the future. When you've changed the component has been changed, then of course it should fail. But do you know if it does now what it should do? No, not based on the snapshot test. What does a developer do now? He/she just assumes everything is okay with the changes, updates the snapshot and pushes the change. Done.

So, the only thing a snapshot test is able is to notify of changes that happened in the component. Well, duh, that's what you'd expect when a developer works on the code.

## What should you do instead?

Plain and simple: Write specific tests for specific expected behaviours. Try to catch edge cases and improve the tests as you go. And especially make sure you write tests for all bugs and issues you find in the future.

Of course, we can not assume developers will think about all the possible edge cases and error states. Snapshot testing won't catch those either. To test for 'unpredicted' behaviour there are techniques like random tests or [fuzz testing (fuzzing)](https://en.wikipedia.org/wiki/Fuzzing).

## Are snapshot tests always wrong?

No. As long as you make sure they don't replace 'normal' tests. They can be helpful in addition to your usual tests to check for unexpected changes which you might not have caught otherwise. Beyond that their usefulness is in my opinion very limited, especially since they might even fail on small 'technical' changes - like whitespace - which would not have any impact on the functionality or actual presentation of a component.
