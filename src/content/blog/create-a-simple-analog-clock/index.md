---
title: 'React: Create a simple analog clock'
date: '2022-08-08T21:15:00.000Z'
description: 'Create a simple analog clock React component and learn a bit about time.'
devTo: 'https://dev.to/syeo66/react-create-a-simple-analog-clock-2k1k'
---

I recently had to create a simple analog clock component for my React project. I now want to share how I approached it.

I built a React component drawing a clock face and three hands for hours, minutes and seconds. I used HTML with Styled Components to style the clock. Of course it could be done with SVG or drawing on a canvas. Maybe I'll explore those options later. For now I wanted to keep it simple and because we do only have 3 moving parts this might not be too much of a performance hog.

Let's start.

## 1. Create a clock face and style it

First we need to have the base component. It will do nothing yet except of drawing the clock face.

```typescript
import React  from 'react'
import styled from 'styled-components'

const DemoClock: React.FC = () => {
  return <Clock />
}

const Clock = styled.div`
  background-color: white;
  border-radius: 50%;
  border: black 1px solid;
  height: 100px;
  margin-bottom: 0.5rem;
  position: relative;
  width: 100px;
`

export default DemoClock
```

This will create a round white background with a black border with a diameter of 100 pixels.

## 2. Add the hands

Now we add the hands. Let's just take the hour hand for example.

```typescript
const Hours = styled.div`
  background-color: black;
  border-radius: 2.5px;
  height: 30px;
  left: calc(50% - 2.5px);
  position: absolute;
  top: 25px;
  width: 5px;
`
```

This will create a 30 pixels long black hand with rounded edges and a small overlap of 5 px in the center.

Let's take a look at some details here:

- `left: calc(50% - 2.5px);`: This will move the hand to the center of the clock. The offset of `-2.5px` is because the hand is 5px wide, so we have to move it to the left by the half of its width.
- `top: 25px;`: This will move the hand down by 25 pixels. 25 pixels because the radius is 50px and we want an overlap of 5 pixels. So `radius - length of hand + overlap = 50 - 30 + 5 = 25`.

Then we add the hand to the clock.

```typescript
const DemoClock: React.FC = () => {
  return (
    <Clock>
      <Hours />
    </Clock>
  )
}
```

Repeat this for the minutes and seconds hand. My clock has now all three hands.

```typescript
const DemoClock: React.FC = () => {
  return (
    <Clock>
      <Hours />
      <Minutes />
      <Seconds />
    </Clock>
  )
}

const Clock = styled.div`
  background-color: white;
  border-radius: 50%;
  border: black 1px solid;
  height: 100px;
  margin-bottom: 0.5rem;
  position: relative;
  width: 100px;
`

const Hours = styled.div`
  background-color: black;
  border-radius: 2.5px;
  height: 30px;
  left: calc(50% - 2.5px);
  position: absolute;
  top: 25px;
  width: 5px;
`

const Minutes = styled(Hours)`
  height: 45px;
  top: 10px;
`

const Seconds = styled(Hours)`
  background-color: red;
  height: 50px;
  top: 5px;
  width: 1px;
`
```

## 3. Make the hours hand displays the current time

Let's start with displaying the current hour. For this we add a `time` prop to the styled component to be able to feed it with any `Date` object.

We know that we have 12 hours on a clock, so we can calculate the angle of the hand for each hour by dividing 360 degrees by 12. This will give us 30 degrees per hour. There is a small caveat: `getHours()` returns up to 24 hours per day. So we have to make sure we only get 12 hours by using a modulo of 12.

```typescript
interface DateProps {
  time: Date
}

const Hours = styled.div<DateProps>`
  ...
  transform-origin: center calc(100% - 5px);
  transform: rotateZ(${({ time }) => ((time.getHours() % 12) * 30}deg);
`
```

We also had to set the pivot point of the rotation to the center of the clock. We do this by setting the transform origin. By using `calc(100% - 5px)` we take care of the 5 pixel overlap of the hand.

Maybe you realize the hand is now jumping from one hour to the but does not move gradually. To achieve a smoother movement we have to do a little bit more maths.

We multiply the hours by 60 and add the current minutes to it. This way the value will reflect the current time in minutes. But now the angle of each unit is different. We do have `12 * 60 = 720` minutes in 12 hours, so we can calculate the angle of each minute by dividing 360 degrees by 720. This will give us 0.5 degrees per minute.

```typescript
const Hours = styled.div<DateProps>`
  ...
  transform: rotateZ(${({ time }) => ((time.getHours() % 12) * 60 + time.getMinutes()) * 0.5}deg);
`
```

## 4. Repeat for the minutes and seconds

We add the rotation of the minutes and seconds hand in a similar way.

```typescript
const Minutes = styled(Hours)`
  ...
  transform: rotateZ(${({ time }) => (time.getMinutes() * 60 + time.getSeconds()) * 0.1}deg);
`

const Seconds = styled(Hours)`
  ...
  transform: rotateZ(${({ time }) => time.getSeconds()  * 6}deg);
`
```

## 5. Update the time

Now we just have to add the time to the clock component. We can do this using a state containing the current time and a timer to update the time every second. Make sure the interval is cleared when the component is unmounted.

```typescript
const DemoClock: React.FC = () => {
  const [time, setTime] = useState(() => new Date())

  useEffect(() => {
    const interval = setInterval(() => {
      const now = new Date()
      setTime(now)
    }, 1000)

    return () => clearInterval(interval)
  }, [])

  return (
    <Clock>
      <Hours time={time} />
      <Minutes time={time} />
      <Seconds time={time} />
    </Clock>
  )
}
```

One small thing to consider. When doing those updates each second, in the worst case the timer could be off by almost one second. Think about this. When the timer runs around 990 milliseconds after the full second, it would seem like being off by one second. Most of the time this is probably not an issue. But you have to think about the needed precision when dealing with time. Let's assume you're working on an auctions platform, then the timing might be quite important and even a second off might annoy some customers.

So, we might want to increase the resolution of the clock to 250 milliseconds or even lower (depending on your needs), but only update the state if the second has changed.

```typescript
  useEffect(() => {
    const interval = setInterval(() => {
      const now = new Date()
      if (now.getSeconds() !== time.getSeconds())) {
        setTime(now)
      }
    }, 250)

    return () => clearInterval(interval)
  }, [time])
```

## 6. One more thing

While this works we created a potential problem. A problem that is rather specific to styled components. Styled components create a new class for each unique combination of props. This means that if you change the props of a component, the class will be recreated. This is a problem for performance. The solution is to use the `attr()` method.

```typescript
const Hours = styled.div.attrs<DateProps>(({ time }) => ({
  style:{
    transform: `rotateZ(${((time.getHours() % 12) * 60 + time.getMinutes()) * 0.5}deg)`,
  },
})).<DateProps>`
   ...
`
```

## Conclusion

We discovered that dealing with time brings certain challenges (we only scratched the surface though - thing's get pretty complicated as soon as you have to synchronize with a server, need precision and/or have to deal with timezones). But there it is: a working clock.

Take a look at the finished implementation in this [gist](https://gist.github.com/syeo66/af150559bb75cde7e77382e935b6fcae).

You can go on and improve the clock: Try adding a day of month field, add indicators for the hours and try different hand designs using pure css or svg. The stage is yours.

That's it. I hope you enjoyed your time.
