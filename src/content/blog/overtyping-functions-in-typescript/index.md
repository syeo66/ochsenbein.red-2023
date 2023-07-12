---
title: 'Typescript: Are you over-typing your functions?'
date: '2022-07-22T21:15:00.000Z'
description: 'When defining a function in Typescript, the first instinct might tell you to just use your existing interfaces or even classes. This might not be optimal...'
devTo: 'https://dev.to/syeo66/typescript-are-you-overtyping-your-functions-52ge'
---
When defining a function in Typescript, the first instinct might tell you to use your existing interfaces or even classes. This might not be optimal. Let's start with a simple example:

```typescript
interface Cat {
  name: string;
  furColor: string;
  age: number;
}

const getName = (cat: Cat): string => {
  return cat.name;
}

const cat: Cat = { name: 'Garfield', furColor: 'orange', age: 3 }

console.log(getName(cat));
```

In this example, the function `getName()` returns the name of the cat (Garfield). So far so good. Now let's assume we introduce a new interface `Person`:

```typescript
interface Person {
  name: string;
  age: number;
}

const person: Person = { name: 'John', age: 30 }

console.log(getName(person));
```

Now typescript would complain about the type of `person`:

```text
Argument of type 'Person' is not assignable to parameter of type 'Cat'.
  Property 'furColor' is missing in type 'Person' but required in type 'Cat'.
```

This makes sense because a person is obviously not a cat (in most cases). But this is too restricting for a function which in actuallity only uses the name of the object it receives.

## Make the function more flexible

The solution is to rewrite the function to make it more flexible:

```typescript
const getName = (obj: { name: string }): string => {
  return obj.name;
}
```

Now we can use it for cats and people, and every other object which has a `name` property. The function does not need anything else to work with, so we should no restrict it artificially.

But why does this work? It works because Typescript only checks if an argument does at least have the properties defined in the interface. It does not compare the actual type and ignores any additional properties in the argument. This also means I had to construct the example this way around to demonstrate my point. If I had used `Person` instead of `Cat` as the type of the parameter, the compiler would have accepted a cat as well. But still, the function is only actually using the `name` property, so why should we expect the parameter to contain an age?

This might seem obvious in this case. But I have seen a lot of more complex functions where the types of the parameters were quite restricting while not even using all the properties in the function.

## One more step

We can do even better by using [generics](https://www.typescriptlang.org/docs/handbook/2/generics.html).

```typescript
const getName = <T extends { name: unknown }>(obj: T): T['name']  => {
  return obj.name;
}
```

This way we don't even have to know the type of `name`. It will be inferred from the type of the object. Of course in this special case, it does not make much sense to have a name be anything else than a string. But it helps to highlight the power of generics.

## Conclusion

This is all I wanted to show you in this article. Don't just slap your existing interfaces on the parameters of a function. Think about what the function actually needs and only requires this. It will make your functions more flexible and easier to reuse.

Generics are a powerful tool to help make your code even more reusable. They are certainly worth exploring even further. But this will be a topic for another time.
