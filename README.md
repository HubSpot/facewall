# Facewall

An open-source version of HubSpot's Facewall and Facewall game.

### [Watch the Video](http://github.hubspot.com/facewall)

## Configuring

- First thing you'll want to do is update the following files:
    - [config.coffee](https://github.com/HubSpot/facewall/blob/master/config.coffee)
    - [constants.coffee](https://github.com/HubSpot/facewall/blob/master/app/constants.coffee)

- Next, you'll want to configure [employees.coffee](https://github.com/HubSpot/facewall/blob/master/app/collections/employees.coffee) with either a URL or `USER_JSON` string. The format of the JSON needs to be the following:

```javascript
{
   "users":[
      {
         "id": 1,
         "createdAt": 1282254176000,
         "email": "aschwartz@hubspot.com",
         "firstName": "Adam",
         "lastName": "Schwartz",
         "role": "Principal Software Engineer"
      },
      // ...
   ]
}
```

## Running

Facewall is a [Brunch](https://github.com/brunch/brunch) app. To run it with no authentication simply run the following:

    brunch watch --server -p PORT

Then navigate to:

    http://localhost:PORT/facewall/

If you want to use SSL, you'll additionally need to set up [stunnel](https://www.stunnel.org/index.html). See the [Stunnel README](https://github.com/HubSpot/facewall/blob/master/STUNNEL_README.md) for more information.

## Deploying

See [Brunch's guide on deploying](http://brunch.io/#deploying).
