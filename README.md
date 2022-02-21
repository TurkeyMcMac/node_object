# node\_object

This is a library mod for Minetest that simplifies associating objects with
nodes. Sometimes nodes need to be displayed or animated in a way that nodes do
not lend themselves to. In these cases, it can be helpful to use an object. For
a concrete example, see the "example" directory. Put this directory in your mod
directory and it will show up as a mod named "spinner\_node" that depends on
the library. It adds a node called a "Spinner." Try placing this node.

## API

### `node_object.set(pos, object)`

Sets the object associated with the node position. If a different object is
already associated, this object is removed. If `object` is `nil`, the
association is cleared.

It is recommended that the object have its property `static_save` set to
`false`, since the association is only in-memory.

In addition, you should optionally depend on `mesecons_mvps` and register the
object's entity type as unmoveable using that mod's API.

### `node_object.get(pos)`

Returns the object (or `nil`) associated with the node position. This will
return `nil` if the object has been removed or deactivated.

### `node_object.swap(pos, object)`

This is like `node_object.set`, but instead of being removed, the past object
(or `nil`) is returned.

### Node callback `_node_object_set(pos)`

An object associated with a node is an ephemeral reflection of the node's state.
By providing this callback in a node definition, you are telling the library to
call it with a node position as its argument when the node may not have an
associated object, such as after placement or loading, and to remove any
associated object before destruction. If the node state changes, you should
update the object yourself.

Note: you cannot set this callback within an `on_mods_loaded` callback.

### `node_object.version`

This is the library's version string. I'll try to stick to SemVer.

## Licenses

All code in this repository is licensed under the MIT license. All other files
are licensed under a [CC BY-SA 3.0 license][1].

[1]: https://creativecommons.org/licenses/by-sa/3.0/
