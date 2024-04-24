# RickyMorty App


<img width="429" alt="screenshot" src="https://github.com/rafaelasenciodev/rickymorty/assets/167070167/771b3726-1260-443d-8b30-e48e6cac318b">


## Use Cases

## Show Rick and Morty character list

### Narrative #1 
>As a online user 

>I want to be able to consult the list of characters of the rick and morty series

>So I can see the details of each character


### Acceptance Criteria

**GIVEN** The customer has connectivity and the app started

**WHEN** The customer access the home view

**THEN** the app should display the list of characters from remote

**AND** handle image caching

___________

* Entities

`Character`
|name|type|
|-|:-:|
|id|Int|
|name|String|
|status|String|
|species|String|
|origin|String|
|image|String|

`Origin`
|name|type|
|-|:-:|
|name|String|
|url|String|

      

    
