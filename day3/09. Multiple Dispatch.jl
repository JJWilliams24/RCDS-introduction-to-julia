### A Pluto.jl notebook ###
# v0.20.4

using Markdown
using InteractiveUtils

# ╔═╡ e2c97e92-288b-11ef-2ed8-33c80ec5cb58
md"""
# Multiple Dispatch

In this notebook we'll explore **multiple dispatch**, which is a key feature of Julia.

Multiple dispatch makes software *generic* and *fast*!

#### Starting with the familiar

To understand multiple dispatch in Julia, let's start with what we've already seen.

We can declare functions in Julia without giving Julia any information about the types of the input arguments that function will receive:
"""

# ╔═╡ 6bc5a40e-f5c7-4b89-b677-0c5657d885c6
f(x) = x ^ 2

# ╔═╡ 973bb8b9-8a93-4f29-9153-e8b1ef0192c7
md"""
and then Julia will determine on its own which input argument types make sense and which do not:
"""

# ╔═╡ b2a34830-30a2-4f77-ab65-41c7e60458cf
f(10)

# ╔═╡ 1da91430-f8b3-4fa4-b49a-0d6a749a7f78
f([1, 2, 3])

# ╔═╡ 5bdd1024-baf0-4ac1-97f5-c98afaf95a10
md"""
#### Specifying the types of our input arguments

However, we also have the *option* to tell Julia explicitly what types our input arguments are allowed to have.

For example, let's write a function `foo` that only takes strings as inputs.
"""

# ╔═╡ df335f51-d67b-49f5-82ab-bc1e17b877de
foo_old(x :: String, y :: String) = "x and y are strings!"

# ╔═╡ 049d69ec-3e06-4909-9fb8-ac6c47240f99
foo_old("hi","Jess")

# ╔═╡ fcc9b9bc-c658-48e2-a8b8-cdfea3895744
foo(x :: String, y :: String) = "$x and $y are strings!"

# ╔═╡ cd84e113-369e-43e8-a75f-6b3d06ae6a20


# ╔═╡ 733c15e3-8407-41f1-8097-c2442ccb903a
md"""
To get `foo` to work on integer (`Int`) inputs, let's tack `::Int` onto our input arguments when we declare `foo`.
"""

# ╔═╡ 0ff1d68f-07c0-4825-942d-3611a29fecba
foo(x :: Int, y :: Int) = "$x and $y are Ints"
#you can see above it says generic function with 2 methods - i.e. there are 2 options to the function

# ╔═╡ 925cf6a7-00dc-4cbe-a020-5137b061f92e
md"""
Looks like the error we had is gone and our call `foo(3, 4)` is working!

But look, `foo` still works when `x` and `y` are strings!
"""

# ╔═╡ 6b8f8894-51be-4ea9-bb9b-d7ede93dc203
md"""
This is starting to get to the heart of multiple dispatch. When we declared

```julia
foo(x::Int, y::Int) = println("My inputs x and y are both integers!")
```
we didn't overwrite or replace
```julia
foo(x::String, y::String)
```

(Remember that Pluto doesn't allow re-definition anyways)

Instead, we just added an additional **method** to the **generic function** called `foo`.

* A **generic function** is the abstract concept associated with a particular operation.
	For example, the generic function `+` represents the concept of addition.

* A **method** is a specific implementation of a generic function for *particular argument types*.

	For example, `+` has methods that accept floats, integers, matrices, etc.

We can use the `methods` function to see how many methods there are for `foo`.
"""

# ╔═╡ cf2f615c-a252-44ab-a71e-cf4eb197d07c
md"""
How many methods do you think there are for addition?
"""

# ╔═╡ 1072d13b-ba10-4537-89f3-03a980ebe960
md"""
So, we now can call `foo` on integers or strings. When you call `foo` on a particular set of arguments, Julia will infer the types of the inputs and dispatch the appropriate method. *This* is multiple dispatch.

Multiple dispatch makes our code generic and fast. Our code can be generic and flexible because we can write code in terms of abstract operations such as addition and multiplication, rather than in terms of specific implementations. At the same time, our code runs quickly because Julia is able to call efficient methods for the relevant types.

To see which method is being dispatched when we call a generic function, we can use `@which`:
"""

# ╔═╡ 570e6e00-2c79-4599-9179-fe69171f4d8d
md"""
Let's see what happens when we use `@which` with the addition operator!
"""

# ╔═╡ f2f2eef1-01f4-47df-8e1e-c16cbc2f54ed


# ╔═╡ f7072093-1e94-4503-9f7c-1dbd093a9524
md"""
We can extend `+` by defining new methods for it. Let's say we want to be able to concatenate strings using `+`. Without extension, this doesn't work.
"""

# ╔═╡ 671a1fa7-9763-45d3-91f4-b23cb7669656
#It doesn't work
#"hello" + "world"

# ╔═╡ 9014afd4-2b06-4dd1-8ea5-0e099c6c90ce
md"""
First we need to import `+` from `Base`, then define a new method. Because of the way Pluto understands imports, we need to add any desired methods in the same cell.
"""

# ╔═╡ 746dd16d-18bc-4403-bef0-01e6735f6c41
begin
	import Base: +
	+(x :: String, y :: String) = x * y #function_name(arguments)
end 

# ╔═╡ c564a209-5fe3-4179-af39-1368c723ac8e
+

# ╔═╡ 8e6b9058-3676-49cb-a0b9-a1feb2ca7405
@which 'C' + 32

# ╔═╡ 716e1715-99ef-4988-98bf-1fe3290309da
'C' + 32

# ╔═╡ 6223976a-8df8-4484-99de-c260aaff3655
@which 32 + 'C'
#Order matters - this is calling a different method

# ╔═╡ a8d5eacb-662b-4b6a-a9e0-24010c93213e
if hasmethod(+, (String, String))
	md"""!!! info "Great, now we can use + to concatenate strings!" """
end

# ╔═╡ 1e44a48e-51b1-414f-a9f3-0c873f0aa267
"hello" + "world"

# ╔═╡ 6aa607f1-67cf-443d-ac5f-732e0a4cfbfd
md"""
We can see our method is being used with the @which macro
"""

# ╔═╡ a4de8391-c2ac-45c9-ae3e-ca3715d37fc4
@which "hi" + "Jess"

# ╔═╡ 21423b73-676a-43d3-8c12-4712aa5f8233
md"""
And we can continue to add other methods to our generic function `foo`. Let's add one that takes the **abstract type** `Number`, which includes subtypes such as `Int`, `Float64`, and other objects you would think of as numbers:
"""

# ╔═╡ 49cd9db5-bfec-498e-984f-28c6012c8da2
foo(x :: Number, y :: Number) = "$x and $y are numbers"

# ╔═╡ 9d175bce-541a-4db6-83ae-e982337b9880
md"""
We can also add a fallback **duck-typed** method to accept any inputs.
"""

# ╔═╡ 021f36c5-ed88-49a8-ac43-d89e78220cdc
foo(x, y) = "quack"
#Use this to pick up an error (me)

# ╔═╡ 64c9eebe-2f51-435f-bd99-8c556de065bc
foo("hi", "Jess")

# ╔═╡ 7a950a95-bc55-4bcf-8ec5-42d1280f179f
foo(1, 2)

# ╔═╡ 60138419-d865-4696-9ac4-1511e8022205
if (@isdefined foo) && hasmethod(foo, (Int, Int))
	md"""!!! info "Looks like foo now works on integers!" """
end

# ╔═╡ 590cfab8-27d8-461a-9393-34303bc7285d
foo("hi","Jess")

# ╔═╡ 28a676c8-db53-4ca8-a78b-cfd550c05478
methods(foo)

# ╔═╡ 3685cabf-14f9-4f54-99f0-406f41f7abcf
@which foo(22, 33)

# ╔═╡ ac017d8c-e44f-4772-b81f-d613f2cc83e3
@which foo(1, 2)
#Julia will find the closest method

# ╔═╡ edff9493-9d48-4ad5-939f-10d9423fdc9e
@which foo(1.0, 2.0)

# ╔═╡ 110f5bae-965a-4d10-988a-f9d713b0d757
v = rand(3, 3)

# ╔═╡ aabd344c-e705-4589-9ba0-1466e3921312
foo(v, v)

# ╔═╡ 45496ae2-7141-4596-9b0c-cb0a74fd78fc
md"""
### Exercise Break

Create a function `safe_square` that will attempt to square any number, any matrix (i.e. $A * A$), but will only print a message if it is passed a vector.
"""

# ╔═╡ 322a9aca-34e6-4a19-98a1-978a80990e41
## YOUR CODE GOES HERE

# ╔═╡ b4dcd4b1-253f-4c2b-af26-718e8fc8255c
## YOUR CODE GOES HERE

# ╔═╡ 6b52ecad-b3c8-4a02-9421-05c4349541b0
## YOUR CODE GOES HERE

# ╔═╡ f632eda2-db84-4b86-9742-daadf81affa1
md"""
#### Tests
"""

# ╔═╡ 59695412-230f-47c6-8eed-d4c315e3ecc1
if (@isdefined safe_square) safe_square(10) end

# ╔═╡ 81819038-24af-4472-abde-302486208a41
if (@isdefined safe_square) safe_square(rand(1:2, 2, 2)) end

# ╔═╡ 10952fca-d15e-499f-9770-fabef4834e7a
if (@isdefined safe_square) safe_square([1, 2, 3]) end

# ╔═╡ Cell order:
# ╟─e2c97e92-288b-11ef-2ed8-33c80ec5cb58
# ╠═6bc5a40e-f5c7-4b89-b677-0c5657d885c6
# ╟─973bb8b9-8a93-4f29-9153-e8b1ef0192c7
# ╠═b2a34830-30a2-4f77-ab65-41c7e60458cf
# ╠═1da91430-f8b3-4fa4-b49a-0d6a749a7f78
# ╟─5bdd1024-baf0-4ac1-97f5-c98afaf95a10
# ╠═df335f51-d67b-49f5-82ab-bc1e17b877de
# ╠═049d69ec-3e06-4909-9fb8-ac6c47240f99
# ╠═fcc9b9bc-c658-48e2-a8b8-cdfea3895744
# ╠═64c9eebe-2f51-435f-bd99-8c556de065bc
# ╠═7a950a95-bc55-4bcf-8ec5-42d1280f179f
# ╠═cd84e113-369e-43e8-a75f-6b3d06ae6a20
# ╟─60138419-d865-4696-9ac4-1511e8022205
# ╟─733c15e3-8407-41f1-8097-c2442ccb903a
# ╠═0ff1d68f-07c0-4825-942d-3611a29fecba
# ╟─925cf6a7-00dc-4cbe-a020-5137b061f92e
# ╠═590cfab8-27d8-461a-9393-34303bc7285d
# ╟─6b8f8894-51be-4ea9-bb9b-d7ede93dc203
# ╠═28a676c8-db53-4ca8-a78b-cfd550c05478
# ╟─cf2f615c-a252-44ab-a71e-cf4eb197d07c
# ╠═c564a209-5fe3-4179-af39-1368c723ac8e
# ╟─1072d13b-ba10-4537-89f3-03a980ebe960
# ╠═3685cabf-14f9-4f54-99f0-406f41f7abcf
# ╟─570e6e00-2c79-4599-9179-fe69171f4d8d
# ╠═8e6b9058-3676-49cb-a0b9-a1feb2ca7405
# ╠═716e1715-99ef-4988-98bf-1fe3290309da
# ╠═6223976a-8df8-4484-99de-c260aaff3655
# ╠═f2f2eef1-01f4-47df-8e1e-c16cbc2f54ed
# ╟─f7072093-1e94-4503-9f7c-1dbd093a9524
# ╠═671a1fa7-9763-45d3-91f4-b23cb7669656
# ╟─a8d5eacb-662b-4b6a-a9e0-24010c93213e
# ╟─9014afd4-2b06-4dd1-8ea5-0e099c6c90ce
# ╠═746dd16d-18bc-4403-bef0-01e6735f6c41
# ╠═1e44a48e-51b1-414f-a9f3-0c873f0aa267
# ╟─6aa607f1-67cf-443d-ac5f-732e0a4cfbfd
# ╠═a4de8391-c2ac-45c9-ae3e-ca3715d37fc4
# ╟─21423b73-676a-43d3-8c12-4712aa5f8233
# ╠═49cd9db5-bfec-498e-984f-28c6012c8da2
# ╠═ac017d8c-e44f-4772-b81f-d613f2cc83e3
# ╠═edff9493-9d48-4ad5-939f-10d9423fdc9e
# ╟─9d175bce-541a-4db6-83ae-e982337b9880
# ╠═021f36c5-ed88-49a8-ac43-d89e78220cdc
# ╠═110f5bae-965a-4d10-988a-f9d713b0d757
# ╠═aabd344c-e705-4589-9ba0-1466e3921312
# ╟─45496ae2-7141-4596-9b0c-cb0a74fd78fc
# ╠═322a9aca-34e6-4a19-98a1-978a80990e41
# ╠═b4dcd4b1-253f-4c2b-af26-718e8fc8255c
# ╠═6b52ecad-b3c8-4a02-9421-05c4349541b0
# ╟─f632eda2-db84-4b86-9742-daadf81affa1
# ╠═59695412-230f-47c6-8eed-d4c315e3ecc1
# ╠═81819038-24af-4472-abde-302486208a41
# ╠═10952fca-d15e-499f-9770-fabef4834e7a
