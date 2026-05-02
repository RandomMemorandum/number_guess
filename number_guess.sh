#!/bin/bash
# ================================================================================

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c "

GAME_NUM_MIN=1
GAME_NUM_MAX=1000

# ================================================================================
# Functions
# ================================================================================
current_timestamp() { echo "$(date '+%Y-%m-%d %H:%M:%S')"; }

generate_random_num() { echo "$(( (RANDOM % (GAME_NUM_MAX - GAME_NUM_MIN + 1)) + GAME_NUM_MIN ))"; }

input_is_number() { local INPUT_VAL=$1; echo "$INPUT_VAL" | grep -q -E "^[0-9]+$"; }

number_in_range()
{
    local INPUT_NUM=$1
    [ $INPUT_NUM -ge $GAME_NUM_MIN ] && [ $INPUT_NUM -le $GAME_NUM_MAX ] && return 0
    return 1
}

get_user_id_for_username()
{
    local USERNAME=$1
    local ROW_COUNT=$($PSQL "SELECT COUNT(1) FROM users WHERE username = '$USERNAME';")
    [ $ROW_COUNT -gt 0 ] && $PSQL "SELECT user_id FROM users WHERE username = '$USERNAME';" && return 0
    echo 0
}

register_user()
{
    local USERNAME=$1
    local INSERT_RESULT=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME');")
    $PSQL "SELECT user_id FROM users WHERE username = '$USERNAME';"
}

welcome_new_user()
{
    local USERNAME=$1
    echo "Welcome, $USERNAME! It looks like this is your first time here."
}

welcome_message()
{
    local USER_ID=$1
    local SESSIONS_FOR_USER=$(get_num_sessions_for_user $USER_ID)
    local LOWEST_GUESS_COUNT=$(get_lowest_guess_count_for_user_victory $USER_ID)
    echo "Welcome back, $USERNAME! You have played $SESSIONS_FOR_USER games, and your best game took $LOWEST_GUESS_COUNT guesses."
}

register_new_session()
{
    local USER_ID=$1
    local SECRET_NUMBER=$2
    local CUR_TIMESTAMP=$(current_timestamp)
    local INSERT_RESULT=$($PSQL "INSERT INTO sessions (user_id, secret_number, game_start) VALUES ($USER_ID, $SECRET_NUMBER, TO_TIMESTAMP('$CUR_TIMESTAMP', 'YYYY-MM-DD HH24:MI:SS'));")
    $PSQL "SELECT session_id FROM sessions WHERE user_id = $USER_ID AND game_start = TO_TIMESTAMP('$CUR_TIMESTAMP', 'YYYY-MM-DD HH24:MI:SS');"
}

get_num_sessions_for_user()
{
    local USER_ID=$1
    $PSQL "SELECT COUNT(1) FROM sessions WHERE user_id = $USER_ID;"
}

enter_winning_guess_count()
{
    local SESSION_ID=$1
    local GUESS_COUNT=$2
    local INSERT_RESUTLT=$($PSQL "UPDATE sessions SET guesses_to_win = $GUESS_COUNT WHERE session_id = $SESSION_ID;")
}

get_lowest_guess_count_for_user_victory()
{
    local USER_ID=$1
    $PSQL "SELECT MIN(guesses_to_win) FROM sessions WHERE user_id = $USER_ID;"
}

# ================================================================================
# Main
# ================================================================================

echo "Enter your username:"
read USERNAME

USERNAME=$(echo "$USERNAME" | xargs)

USER_ID=$(get_user_id_for_username $USERNAME)
if [ $USER_ID -gt 0 ]; then
    welcome_message "$USER_ID"
else
    welcome_new_user $USERNAME
    USER_ID=$(register_user $USERNAME)
fi

SECRET_NUMBER=$(generate_random_num)

SESSION_ID=$(register_new_session $USER_ID $SECRET_NUMBER)

echo "Guess the secret number between 1 and 1000:"

GUESS_COUNT=0
GUESS_MATCHES_SECRET_NUMBER='NO'
while [ "$GUESS_MATCHES_SECRET_NUMBER" = 'NO' ]; do
    read INPUT_GUESS
    if [ -z "$INPUT_GUESS" ]; then
        echo "That is not an integer, guess again:"
        continue
    elif ! input_is_number $INPUT_GUESS; then
        echo "That is not an integer, guess again:"
        continue
    fi
    ((GUESS_COUNT++))
    if ! number_in_range $INPUT_GUESS; then
        continue
    elif [ $INPUT_GUESS -eq $SECRET_NUMBER ]; then
        echo "You guessed it in $GUESS_COUNT tries. The secret number was $SECRET_NUMBER. Nice job!"
        enter_winning_guess_count $SESSION_ID $GUESS_COUNT
        GUESS_MATCHES_SECRET_NUMBER='YES'
    elif [ $INPUT_GUESS -lt $SECRET_NUMBER ]; then
        echo "It's higher than that, guess again:"
    elif [ $INPUT_GUESS -gt $SECRET_NUMBER ]; then
        echo "It's lower than that, guess again:"
    fi
done
