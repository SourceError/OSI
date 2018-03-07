
function osi.sql.create_tables()
    MySQL.Sync.execute([[CREATE TABLE IF NOT EXISTS client(
        id INTEGER AUTO_INCREMENT,
        steam_id VARCHAR(32),
        last_login DATETIME,
        white BOOLEAN,
        black BOOLEAN,
        credits SMALLINT,
        CONSTRAINT pk_client PRIMARY KEY(id)
        );]], {})

    MySQL.Sync.execute([[CREATE TABLE IF NOT EXISTS character(
        id INTEGER AUTO_INCREMENT,
        client_id INTEGER,
        first_name VARCHAR(32),
        last_name VARCHAR(32)
        sex VARCHAR(16),
        dob DATE,
        created DATE,
        CONSTRAINT pk_character PRIMARY KEY(id)
        CONSTRAINT fk_client_id_client FOREIGN KEY(client_id) REFERENCES client(id) ON DELETE CASCADE
        );]], {})

    MySQL.Sync.execute([[CREATE TABLE IF NOT EXISTS attributes(
        character_id INTEGER,
        strength TINYINT,
        dexterity TINYINT,
        intelligence TINYINT,
        CONSTRAINT pk_attributes PRIMARY KEY(character_id)
        CONSTRAINT fk_character_id_character FOREIGN KEY(character_id) REFERENCES character(id) ON DELETE CASCADE
        );]], {})

    MySQL.Sync.execute([[CREATE TABLE IF NOT EXISTS money(
        character_id INTEGER,
        cash BIGINT,
        bank BIGINT,
        CONSTRAINT pk_money PRIMARY KEY(character_id)
        CONSTRAINT fk_character_id_character FOREIGN KEY(character_id) REFERENCES character(id) ON DELETE CASCADE
        );]], {})

    MySQL.Sync.execute([[CREATE TABLE IF NOT EXISTS inventory(
        character_id INTEGER,
        slot INTEGER,
        item_type_id INTEGER,
        amount INTEGER,
        CONSTRAINT pk_inventory PRIMARY KEY(character_id, slot)
        CONSTRAINT fk_character_id_character FOREIGN KEY(character_id) REFERENCES character(id) ON DELETE CASCADE
        );]], {})
end

function osi.sql.create_client(data)
    MySQL.Sync.execute([[INSERT IGNORE INTO client(steam_id, white, black, credits) 
                        VALUES(@steam_id, @whitelist, false, 0);]],
                        { 
                            ['@steam_id'] = data.steam_id, 
                            ['@whitelist'] = data.whitelist
                        }
    )
end

function osi.sql.create_character(data) 
    -- Get sex_id from table of genders
    -- Format date of birth to a date
    local character = MySQL.Sync.execute([[INSERT INTO character(client_id, first_name, last_name, sex, dob, created)
                        VALUES(@client_id, @first, @last, @sex, @dob, @created); SELECT LAST_INSERT_ID() AS id]],
                        {
                            ['@client_id'] = data.client_id,
                            ['@first'] = data.first_name,
                            ['@last'] = data.last_name,
                            ['@sex'] = data.sex,
                            ['@dob'] = dob_formatted,
                            ['@created'] = created_formatted
                        }
    )

    local character_id = character[1].id
    MySQL.Sync.execute([[INSERT INTO attributes(character_id, strength, dexterity, intelligence)
                        VALUES(@character_id, @str, @dex, @int);]],
                        {
                            ['@character_id'] = character_id,
                            ['@str'] = data.strength,
                            ['@dex'] = data.dexterity,
                            ['@int'] = data.intelligence
                        }
    )

    MySQL.Sync.execute([[INSERT INTO money(character_id, cash, bank)
                        VALUES(@character_id, @cash, @bank);]],
                        {
                            ['@character_id'] = character_id,
                            ['@cash'] = data.cash,
                            ['@bank'] = data.bank
                        }
    )

    return character[1]
end

function osi.sql.get_client_data(steam_id)
    local clients = MySQL.Sync.fetchAll('SELECT id, white, black, credits FROM client WHERE steam_id=@steam;', 
         { 
         ['@steam'] = steam_id 
         })
    return clients[1]
end

function osi.sql.get_characters(client_id)
    local characters = MySQL.Sync.fetchAll('SELECT id, first_name, last_name, sex, dob, created FROM character WHERE client_id=@client_id;', 
        {
        ['@client_id'] = client_id
        })
    return characters
end

function osi.sql.get_character_data(character_id)
    local characters = MySQL.Sync.fetchAll('SELECT id, first_name, last_name, sex, dob, created FROM character WHERE id=@character_id;', 
        {
        ['@character_id'] = character_id
        })
    return characters[1]
end

function osi.sql_get_attribute_data(character_id)
    local attributes = MySQL.Sync.fetchAll('SELECT strength, dexterity, intelligence FROM attributes WHERE character_id=@character_id;', 
        {
        ['@character_id'] = character_id
        })
    return attributes
end

function osi.sql.get_money_data(character_id)
    local money = MySQL.Sync.fetchAll('SELECT cash, bank FROM money WHERE character_id=@character_id;', 
        {
        ['@character_id'] = character_id
        })
    return money
end

function osi.sql.delete_character(character_id)
    local result = MySQL.Sync.execute('DELETE FROM character WHERE id=@character_id;', {
        ['@character_id'] = character_id
        })
end