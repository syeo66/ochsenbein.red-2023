---
title: 'React: Switch background images when they are ready'
date: '2022-12-08T21:15:00.000Z'
description: 'I created a changing background image and made sure it loads before displayed.'
devTo: 'https://dev.to/syeo66/react-switch-background-images-when-they-are-ready-896'
---

In an application I'm currently working on I needed a way to make sure the image is actually loaded before I put it into the background. How did I do that?

Actaully it's pretty simple: Create an image object, load the image - which then would be put into the cache - and when the image object sends the load event switch the image.

```typescript
import React, { PropsWithChildren, useCallback, useState } from 'react'
import styled from 'styled-components'

import useWsMessage from '../hooks/useWsMessage'

interface BackgroundData {
  credits?: string
  url: string
}

const Background: React.FC<PropsWithChildren> = ({ children }) => {
  const [current, setCurrent] = useState<BackgroundData | null>(null)

  const handleMesssage = useCallback((event: MessageEvent<string>) => {
    const raw = event.data.replace('SetBackground ', '')
    try {
      const background: BackgroundData = JSON.parse(raw)
      const img = new Image()
      img.src = background.url
      img.onload = () => setCurrent(background)
    } catch {
      // do nothing
    }
  }, [])

  useWsMessage('SetBackground', handleMesssage)

  return (
    <BackgroundRenderer url={current?.url}>
      {children}
    </BackgroundRenderer>
  )
}

interface BackgroundRendererProps {
  url?: string
}

const BackgroundRenderer = styled.div.attrs<BackgroundRendererProps>(({ url }) => {
  return {
    style: { backgroundColor: 'black', ...(url ? { backgroundImage: `url(${url})` } : {}) },
  }
})<BackgroundRendererProps>`
  background-position: center center;
  background-size: cover;
  background-repeat: no-repeat;
  bottom: 0;
  height: 100%;
  left: 0;
  position: fixed;
  right: 0;
  top: 0;
  width: 100%;
`

export default Background
```

As you can see the component retrieves a message from websocket and uses the URL to set the background image. The important part is this:

```typescript
const img = new Image()
img.src = background.url
img.onload = () => setCurrent(background)
```

It creates an image object, sets the src and sets the background image state as soon as the image is loaded.

That's it. Pretty simple, huh? I hope this helps someone having a similar problem in the future.
