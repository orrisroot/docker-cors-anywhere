# cors-anywhere docker image

This image provides [cors-anywhere](https://www.npmjs.com/package/cors-anywhere) service. 

## Example

### Run

```sh
docker run --restart always -d --name cors-anywhere -p 8080:8080 orrisroot/cors-anywhere
```

### Request

```sh
curl --request GET \
  --url http://localhost:8080/http://example.com \
  --header 'origin: *'
```
