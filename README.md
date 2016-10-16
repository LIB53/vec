# Vec

Pure elixir vector math library. I've written this as an exercise. Almost all
the functions I've written can be found in the
[graphmath](https://hexdocs.pm/graphmath/api-reference.html) package on hex. 

## Exercise Remarks
The library was written ask an excuse to spend more time with elixir, and also
to take a look at the pipe operator in elixir. As a result, it is well suited
for composing long sequences of vector calculations.

### Some comments on implementation...
I didn't really look at performance as a key issue here. Instead, I've tried to
write the functions in a way that makes the best use of functional programming.
Most functions use `map` and `zip`, with `add`, `sub` and `scale` being merely
aliases of map and zip.

Divide by zero errors were also avoided where they occur by mimicking the
behavior found in the Unity game engine. However, it is still possible to
customize the behavior for `undefined` by passing the term as an additional
parameter so that users can define the condition as it suits their program.
 
Overall, I'm finding the syntax for elixir to be very approachable, and
surprisingly intuitive. It only takes using an elixir feature a couple times to
remember it.

## Compile
```elixir
mix compile
```

## Run Tests
```elixir
mix test
```
