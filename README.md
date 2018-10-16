# Jsonista

## What it is
Currently an exersize in building a lean and fast templating engine for ruby,
and written in pure ruby, that outputs json.

## How it works
Internally, a template is processed in two phases:
- a compile phase, that evaluates the templates contents into a ruby structure
- a serialization phase, that converts the compiled structure into json

## The templating DSL
The primary DSL is pure ruby; build the structure that needs to be serialized
with ruby strings, symbols, hashes, arrays, true, false and nil.

### Rendering Subtemplates
From within a template, other templates can be rendered. The resulting structure
of their rendering call (actually the compilation step as described above)
will be inserted at the place of the render call.

Two additional top level methods are available within templates: render and
cache.

##### Invocation
Giving template file locations directly:
```
  render( filename )
```
This will assume that the filename is given exactly.

Giving a template file:
```
  render( :template => template_path )
```
This will resolve the template path relative to the calling template, and 
add the file extension to the given template path if required.

Rendering a partial:
```
  render( :partial => partial_path )
```
Similar to render( :template ), however prefixes the template filename with
an underscore before reading the resulting file, i.e. we're using the Rails
style naming convention for partials: 
```
  render( :partial => "foo" )
```
will try to render the file "\_foo.jsonista" in the directory containing the
template issuing the call.

Rendering a template from a string:
```
  render( :string => tempate_body )
```
Renders the template body directly.

Local variables:
```
  render( :partial => "foo",
          :locals  => { :var_1 => "value 1",
                        :var_2 => :value_2 } )
```
Each render invocation can be given a set of local variables. These will then
be accessible in the called template.

Rendering collections:
```
  render( :partial => "foo", :collection => @array_of_values )
```
Renders the given partial once for each element in the given array of values,
returning an array of resulting structures. Within the given partial, the
current value is accessible through the variable "instance".

### Caching

In order to use caching, first, you need to set up the cache:
```
  Jsonista.cache = Jsonista::Cache::InMemory.new
```

Then, you can call the top level cache function from within your template:
```
  cache( :key ) do
    "stuff that should be cached"
  end
```

If the given key is known in the cache at serialization time, the cached value
is inserted in place of the cache call within the resulting json. Otherwise
the contents of the passed block is compiled, serialized, stored in the cache
and inserted in place fo the cache call.

### Helpers
Helper methods can be made available within templates by setting the modules 
from which the helpers should be loaded.
```
  Jsonista.helpers = [ HelperModule1, HelperModule2 ]
```
Note: If you specify the helpers again, the previous helpers will be removed.

## TODOs
- Check (user defined) objects left over after compilation for an #as\_json
  method and call that to compile the object.
- Add more caches: NullCache, FileCache, RedisCache
- Add a configuration system
