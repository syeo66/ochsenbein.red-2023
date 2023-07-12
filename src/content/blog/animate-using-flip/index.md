---
title: 'Animating HTML Elements Using FLIP'
date: '2022-08-06T21:15:00.000Z'
description: 'FLIP - First, Last, Invert, Play.'
devTo: 'https://dev.to/syeo66/animating-html-elements-using-flip-ngd'
---
In modern web apps you come across the need to animate HTML elements. Be it to visualize the transition between multiple lists, switching positions in one list, growing elements on selection, etc. There are many cases to make your app feel more 'flashy' by animating stuff.

While doing that you will notice that there will be some questions to answer. How do we deal with the element changing the DOM. When and how to initiate the animation. Should we clone the element or just reuse it. In no way I'm suggesting FLIP will just answer all those questions. But it will give you a good starting point to make the management of the animation a bit easier.

The trick is to not start with the elements starting position, but with it's final position. All this will get clearer as we describe what FLIP means:

FLIP stands for First, Last, Invert and Play and was coined by [Paul Lewis](https://aerotwist.com/).

- **First:** The elements starting point. Gather this information from the DOM.
- **Last:** The elements final position. Also retrieve this information from the DOM.
- **Invert:** Calculate the transformation (scale, rotate, translate, etc.) from the first to the last position and reverse it. So if you have to animate 100px to the right, use -100px on the x axis. This will display your element at the same position as it was before.
- **Play:** Start the animation. It will now transition from the reversed starting position to the current position. Nothing elese needs to be done.

Let's take a look at an example:

```typescript
const flip = () => {
  // retrieve the block to animate
  const block1 = document.querySelector<HTMLDivElement>('#block1')

  // an array with 3 target elements
  const positions: Element[] = [
    document.querySelector('.middle'),
    document.querySelector('.end'),
    document.querySelector('.start'),
  ]
  let index = 0

  if (block1) {
    // animate the block on click
    block1.addEventListener('click', () => {
      // FLIP - First
      // retrieve the position of the block at its starting point
      const start = block1.getBoundingClientRect()

      // Move the element to its destination
      positions[index].appendChild(block1)

      // FLIP - Last
      // retrieve the position of the block at its final position
      const end = block1.getBoundingClientRect()

      // FLIP - Invert
      // Calculate the change from the start to the end position
      const dx = start.left - end.left
      const dy = start.top - end.top
      const dh = start.height - end.height
      const dw = start.width - end.width

      // FLIP - Play
      // Initiate the animation
      block1.animate(
        [
          {
            transformOrigin: 'top left',
            transform: `translate(${dx}px, ${dy}px)`,
            height: `${dh}px`,
            width: `${dw}px`,
          },
          {
            transformOrigin: 'top left',
            transform: 'none',
          },
        ],
        { duration: 400, fill: 'both', easing: 'ease-in-out' }
      )

      index = (index + 1) % positions.length
    })
  }
}
```

When playing with FLIP you might run into some problems though:

- When scaling the elements it can get pretty hard to deal with rounded borders.
- Rotating element is not as easy as it sounds.
- Dealing with multiple animations can be rather tricky.
- Sometimes you don't want to change the elements width or height, but rather use the scale transformation. But this will make it harder to deal with rounded borders or font-sizes, etc.

Anyways, there is a nice [GSAP plugin](https://greensock.com/docs/v3/Plugins/Flip/) awailable to deal with those issues and more.
