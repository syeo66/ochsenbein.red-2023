---
title: 'Comparing "Agile" to the scientific process'
date: '2022-07-26T21:15:00.000Z'
description: 'Let''s take at the scientific process and compare it to "Agile", and which important steps usually get skipped.'
devTo: 'https://dev.to/syeo66/comparing-agile-to-the-scientific-process-24mb'
---
If you are a Software Engineer or are involved in any kind of software development you probably heard something about "Agile".
Also, you probably noticed there are about as many opinions on what "Agile" is as there are people, and some more.

In this article, I'll argue that the agile process is in fact (or at least should be) the same as the scientific process.

## The scientific process

The scientific process in its basic form is pretty simple and includes the following steps:

- Formulate a hypothesis
- Design an experiment
- Build the experiment
- Perform the experiment
- Gather the data
- Analyze the data and draw conclusions
- Rinse and repeat

Of course, there might be substeps. For instance to formulate a proper hypothesis you'd have to start with a question and do some preliminary research. But we are looking at the main idea of the process here.

## The agile process

The agile process looks quite similar:

- Define the iteration's (also called a sprint) goal
- Write the stories, requirements and acceptance criteria
- Develop the defined features
- Deploy the feature
- Gather data and feedback
- Analyze the data and draw conclusions
- Rinse and repeat

I think you start to see the similarities. Let's take a look at the steps of the scientific process and see how they translate to the agile process.

### Formulate a hypothesis

Formulating a hypothesis means you start with a question, gather existing information and research, and come up with an idea you want to test. The same should be true for this iteration's goal: See where you stand in the project, retrieve information about the stakeholders' needs, and define a goal.

### Design an experiment

Designing an experiment means you take your hypothesis and think about the consequences if it were true. What testable predictions can you make? How can you test it? What do you need to build and how can you make sure you are really testing your hypothesis and not something else? This is one of the hardest parts of the scientific process. Getting an experiment right is notoriously hard and you have to be precise. Not only do you need to build the experiment itself but you also need to know what data you might need to collect and how to collect it.

This is pretty similar to defining the requirements of a feature (story, task, or whatever you want to call it). It is very important to exactly know what you want to achieve, and be specific. You have to define acceptance criteria. At the end of this, you should know exactly what the feature does, and how to measure if the feature is successful (in contrast to 'it is just working').

### Build the experiment

Building an experiment can be as simple as printing some questionnaires or as hard as having to build a machine like the LHC at CERN. The most important thing is to know what you are building based on the design of the experiment.

This is the step where the software gets built. Based on the specifications and acceptance criteria your team builds the features. Similar to the science experiment this can be as simple as adding a button or as complex as implementing a new ML/AI algorithm.

### Run the experiment

This step does not need many words. Conduct the experiment and make sure you receive all the data you defined in the design.

The same is true in the agile process: Deploy it and make sure you receive the feedback and data you need to measure the impact and success of the feature.

### Gather the data

After running the experiment you should have a bunch of data to compile. Collecting and organising the data to be able to conclude later is a critical step. Based on the experiment's design you have to make sure everything is there and prepared to be analysed.

This is the same you have to do in an agile process. Gather the data which will inform you about the outcome of the feature development. Get feedback from stakeholders and retrieve analytics data you hopefully deployed with the feature. After all, you defined those in the requirements, right?

### Analyze the data and draw conclusions

The data needs to be analyzed and based on what you learn you try to come to conclusions. There is the review step of the agile process, and to be frank, this is what makes 'Agile' agile. Only when you have good data, and carefully draw conclusions based on the facts you can make sure you stay on track. In the scientific process, this step makes or breaks your hypothesis. You learn if your hypothesis is (or at least might) be true and if you need to try something different. Maybe you will have to decide if this experiment was not providing you with the data you needed and you have to get back to the drawing board. This is the same you should do in your agile development.

### Rinse and repeat

After you went through all the steps you are ready to go back to the start and do the same thing all over again. This way you'll experience incremental improvement of knowledge, collaboration and the outcome of whatever you are working on.

## What steps are skipped quite often?

In my experience companies seem to skip some of the most crucial steps. **Requirements** are often quite vague and it often feels like they see 'Agile' as a way to just move the responsibility of the project's design down to the developers. There is never only one way to approach a new feature, so there will probably be as many expectations as there are people involved. Without defining the requirements it's pretty much a given that at least one important stakeholder will not be happy with the result.

Also, without detailed requirements and acceptance criteria, there is no way to say if a feature is finished, if it works correctly or if we even retrieve enough information to measure the impact of that feature.

The other steps I saw missing a lot of time in a project are deployment and when something has been deployed, **gathering information** was neglected.

Quite often the sprint **review** just consists of a sprint demo and review, and nothing else. It seems not to be unusual to not see any actions taken based on the sprint review. So, what is agile about that process then?

I think it would be important to gather information - which also requires you to build an environment and culture allowing everyone to speak up freely - analyze the data and **take action** based on that.
