### How to run tests

1. Get your oath token following the [api documentation](https://desk.zoho.com/DeskAPIDocument#OauthTokens%23MakingTheAuthorizationRequest) and place it in your .env

```sh
echo "ACCESS_TOKEN=<your_oath_token_here>" >> .env
```

2. `bundle install`

3. `ruby ./test/zoho_desk.rb`