---
title: 'React Query: How to organize your keys'
date: '2022-08-01T21:15:00.000Z'
description: 'As soon as your React application grows a bit larger, key organization gets more important. One approach...'
devTo: 'https://dev.to/syeo66/react-query-how-to-organize-your-keys-4mg4'
---
If you're using React Query you certainly know how the `useQuery` hook works. Some example similar to the ones you find in the [React Query documentation](https://react-query-v3.tanstack.com/guides/query-keys).

```typescript
// a simple string.only key
useQuery('todos', ...)

// an array key
useQuery(['todo', id], ...)

// other, more complex keys
useQuery(['todo', id, 'comments', commentId], ...)
useQuery(['todo', {id, type: 'comments', commentId}], ...)
```

These keys are used to identify a specific query and is most important in combination with react query's caching mechanism. It allows react query to fetch the same query only once even if it is called multiple times in various components, and it identifies the cache to be used when fetching again or invalidating the cache.

In larger applications you'd have to make sure the keys are identical in all components or hooks using the same query or even more important if you want to invalidate the cache (aftera mutation, for example).

The react query documention does not provide a solution to this problem. My solution for this is pretty straightforward. By creating an object with a `key` and `query` function for each query.

```typescript
const todoQuery = {
  key: (id: string): ['todo', string] => ['todo', id],
  query: (id: string): Promise<...> => {... fetch the todos ...},
}
export default todoQuery
```

Using useQuery would then look like this:

```typescript
const { data, isLoading } => useQuery(todoQuery.key(id), () => todoQuery.query(id))
```

I think this is a simple but effective way to make sure the keys are always the same. Even when the keys need to change for some reason, you always alter them for all the places they have been used.
