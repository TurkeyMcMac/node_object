# node\_object

This is a library mod for Minetest that simplifies associating objects with
nodes. Sometimes nodes need to be displayed or animated in a way that nodes do
not lend themselves to. In these cases, it can be helpful to use an object. For
a concrete example, see the "example" directory. Put this directory in your mod
directory and it will show up as a mod named "spinner\_node" that depends on
the library. It adds a node called a "Spinner." Try placing this node.

## API

To make a node use the library, put a callback `_node_object_set` in its
definition (you cannot do this in an `on_mods_loaded` callback.) This callback
takes one argument, the node position, and defines how to set the associated
object. It will be called when the node is added or when it is loaded. When the
node is added, the callback is called before the `on_construct` callback.
Because associations are only kept in-memory, you should probably set
`static_save = false` in the associated object's properties. It is also a good
idea to optionally depend on "mesecons\_mvps" and make the object unmoveable if
this mod is present.

When a node is destroyed, its associated object is removed after the
`on_destruct` callback.

The main function you will need in your callback is
`node_object.set(pos, object)`. `pos` is the node position and `object` is some
object or `nil`. If a different object is already associated with the position,
it is removed. The new object is then set, unless `object` is `nil`. 

`node_object.get(pos)` gets the object associated with the node position. It
will return `nil` if the object is not set or has been removed or deactivated.

`node_object.swap(pos, object)` is like `node_object.set`, but instead of
removing the old object, it will return it (or `nil`) like `node_object.get`.

The library version string is available in `node_object.version`. I'll try to
stick to SemVer.
