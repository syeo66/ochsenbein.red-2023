---
title: 'Typescript: It''s not actually validating your types.'
date: '2022-08-11T21:15:00.000Z'
description: 'Types in typescript try to ensure you are working with the data you expect. But...'
devTo: 'https://dev.to/syeo66/typescript-its-not-actually-validating-your-types-1mn3'
---

Typescript is a nice thing: It lets you define types and make sure your classes and functions adhere to certain expectations. It forces you to think about what data you put into a function and what you will get out of it. If you get that wrong and try to call a function which expects a sting with a - let's say - number, the compiler will let you know. Which is a good thing.

Sometimes this leads to a misconception: I met people who believed typescript would make sure the types are what you say you are. But I have to tell you: Typescript does not do that.

Why? Well, Typescript is working on compiler level, not during the runtime. If you take a look at how the code Typescript produces does look like you'll see it translates to Javascript and strips all the types from the code. 

Typescript code:
```typescript
const justAFunction = (n: number): string => {
  return `${n}`
}

console.log(justAFunction)
```

The resulting Javascript code (assuming you are transpiling to a more recent EcmaScript version):
```typescript
"use strict";
const justAFunction = (n) => {
    return `${n}`;
};
console.log(justAFunction);
```

It only checks if the types seem to be correct based on your source code. It does not validate the actual data.

## Checking types

Is typescript useless then? Well, no, far from it. When you use it right it forces you to check your types if there are no guarantees ("unfortunately" it also provides  some easy ways out).

Let's change our example a little bit:
```typescript
const justAFunction = (str: string[] | string): string => {
  return str.join(' ') 
}

console.log(justAFunction(["Hello", "World"]))
console.log(justAFunction("Hello World"))
```

When compiling this will lead to the following error:
```
index.ts:2:14 - error TS2339: Property 'join' does not exist on type 'string | string[]'.
  Property 'join' does not exist on type 'string'.

2   return str.join(' ')
               ~~~~


Found 1 error in index.ts:2
```

The compiler forces to think about the type of the variable `str`. One solution would be to only allow `string[]` into the function. The other is to test if the variable contains the correct type. 

```typescript
const justAFunction = (str: string[] | string): string => {
  if (typeof str === 'string') {
    return str
  }

  return str.join(' ') 
}

console.log(justAFunction(["Hello", "World"]))
console.log(justAFunction("Hello World"))
```

This would also translate into Javascript and the type would be tested. In this case we would only have a guarantee that it is a `string` and we would only be assuming it is an array.

In many cases this is good enough. But as soon as we have to deal with external data source - like APIs, JSON files, user input and similar - we should not assume the data is correct. We should validate the data and there is an opportunity to ensure the correct types.

## Mapping external data to your types

So the first step to solve this problem would probably be to create actual types to reflect your data.

Let's assume the API returns a user record like this:

```json
{
  "firstname": "John",
  "lastname": "Doe",
  "birthday": "1985-04-03"
}
```

Then we may want to create an interface for this data:

```typescript
interface User {
  firstname: string
  lastname: string
  birthday: string
}
```

And use fetch to retrieve the user data from the API:

```typescript
const retrieveUser = async (): Promise<User> => {
  const resp = await fetch('/user/me')
  return resp.json()
}
```

This would work and typescript would recognize the type of the user. But it might lie to you. Let's say the birthday would contain a number with the timestamp (might be somewhat problematic for people born before 1970... but that's not the point now). The type would still treat the birthday as a string despite having an actual number in it... and Javascript will treat it as a number. Because, as we said, Typescript does not check the actual values.

What should we do now. Write a validator function. This might look something like this:

```typescript
const validate = (obj: any): obj is User => {
  return obj !== null 
    && typeof obj === 'object'
    && 'firstname' in obj
    && 'lastname' in obj
    && 'birthday' in obj
    && typeof obj.firstname === 'string'
    && typeof obj.lastname === 'string'
    && typeof obj.birthday === 'string'
}

const user = await retrieveUser()

if (!validate(user)) {
  throw Error('User data is invalid')
}
```

This way we can make sure the data is, what it claims to be. But you might see this can get quickly get out of hands in more complex cases.

There are protocols inherently dealing with types: [gRPC](https://grpc.io), [tRPC](https://trpc.io), validating JSON against a [schema](https://json-schema.org) and [GraphQL](https://graphql.org) (to a certain extend). Those are usually very specific for a certain usecase. We might need a more general approach.

## Enter Zod

[Zod](https://zod.dev) is the missing link between Typescript's types and enforcing the types in Javascript. It allows you to define the schema, infer the type and validate the data in one swipe.

Our `User` type would be defined like this:

```typescript
import { z } from 'zod'

const User = z.object({
    firstname: z.string(),
    lastname: z.string(),
    birthday: z.string()
  })
```

The type could then be extracted (inferred) from this schema.

```typescript
const UserType = z.infer<User>
```

and the validation looks like this

```typescript
const userResp = await retrieveUser()
const user = User.parse(userResp)
```

Now we have a type and validated data and the code we had to write is only marginally more than without the validation function.

## Conclusion

When working with Typescript it is important to know the difference between compiler checks and runtime validation. To make sure external data are conforming to our types we need to have some validation in place. Zod is great tool to deal with exactly that without much overhead and in a flexible way.

Thanks for reading.
