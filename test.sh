echo "TEST"

export FOO=https://pokeapi.co/api/v2/pokemon/ditto
export BAR=$(curl $FOO | jq .base_experience)

echo $BAR