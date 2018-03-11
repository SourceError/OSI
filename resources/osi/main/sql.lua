osi.sql = {}

function osi.sql.create_tables()
    MySQL.Sync.execute([[CREATE TABLE IF NOT EXISTS osi_client(
        id INTEGER AUTO_INCREMENT,
        steam_id VARCHAR(32),
        steam_name VARCHAR(64),
        last_login DATETIME,
        white BOOLEAN,
        black BOOLEAN,
        credits SMALLINT,
        CONSTRAINT pk_osi_client PRIMARY KEY(id)
        );]], {})

    MySQL.Sync.execute([[CREATE TABLE IF NOT EXISTS osi_character(
        id INTEGER AUTO_INCREMENT,
        client_id INTEGER,
        first_name VARCHAR(32),
        last_name VARCHAR(32),
        sex VARCHAR(16),
        dob DATE,
        created DATE,
        CONSTRAINT pk_osi_character PRIMARY KEY(id),
        CONSTRAINT fk_osi_character_client FOREIGN KEY(client_id) REFERENCES osi_client(id) ON DELETE CASCADE
        );]], {})

    MySQL.Sync.execute([[CREATE TABLE IF NOT EXISTS osi_attributes(
        character_id INTEGER,
        strength TINYINT,
        dexterity TINYINT,
        intelligence TINYINT,
        CONSTRAINT pk_osi_attributes PRIMARY KEY(character_id),
        CONSTRAINT fk_osi_attributes_character FOREIGN KEY(character_id) REFERENCES osi_character(id) ON DELETE CASCADE
        );]], {})

    MySQL.Sync.execute([[CREATE TABLE IF NOT EXISTS osi_money(
        character_id INTEGER,
        cash BIGINT,
        bank BIGINT,
        CONSTRAINT pk_osi_money PRIMARY KEY(character_id),
        CONSTRAINT fk_osi_money_character FOREIGN KEY(character_id) REFERENCES osi_character(id) ON DELETE CASCADE
        );]], {})

    MySQL.Sync.execute([[CREATE TABLE IF NOT EXISTS osi_inventory(
        character_id INTEGER,
        slot INTEGER,
        item_type_id INTEGER,
        amount INTEGER,
        CONSTRAINT pk_osi_inventory PRIMARY KEY(character_id, slot),
        CONSTRAINT fk_osi_inventory_character FOREIGN KEY(character_id) REFERENCES osi_character(id) ON DELETE CASCADE
        );]], {})
end

function osi.sql.create_client(data)
    MySQL.Sync.execute([[INSERT INTO osi_client(steam_id, steam_name, white, black, credits) 
                        VALUES(@steam_id, @steam_name, @whitelist, false, 0);]],
                        { 
                            ['@steam_id'] = data.steam_id, 
                            ['@steam_name'] = data.steam_name, 
                            ['@whitelist'] = data.whitelist
                        }
    )
end

function osi.sql.create_character(data) 
    -- Get sex_id from table of genders
    -- Format date of birth to a date
    MySQL.Sync.execute([[INSERT INTO osi_character(client_id, first_name, last_name, sex, dob, created)
                        VALUES(@client_id, @first, @last, @sex, @dob, @created);]],
                        {
                            ['@client_id'] = data.client_id,
                            ['@first'] = data.first_name,
                            ['@last'] = data.last_name,
                            ['@sex'] = data.sex,
                            ['@dob'] = data.dob,
                            ['@created'] = data.created
                        }
    )

    local character = MySQL.Sync.fetchAll([[SELECT LAST_INSERT_ID() AS id;]])
    local character_id = character[1]["id"]

    MySQL.Sync.execute([[INSERT INTO osi_attributes(character_id, strength, dexterity, intelligence)
                        VALUES(@character_id, @str, @dex, @int);]],
                        {
                            ['@character_id'] = character_id,
                            ['@str'] = data.strength,
                            ['@dex'] = data.dexterity,
                            ['@int'] = data.intelligence
                        }
    )

    MySQL.Sync.execute([[INSERT INTO osi_money(character_id, cash, bank)
                        VALUES(@character_id, @cash, @bank);]],
                        {
                            ['@character_id'] = character_id,
                            ['@cash'] = data.cash,
                            ['@bank'] = data.bank
                        }
    )

    return character_id
end

function osi.sql.get_client_data(steam_id)
    local clients = MySQL.Sync.fetchAll("SELECT id, white, black, credits FROM osi_client WHERE steam_id=@steam;", 
        {
        ['@steam'] = steam_id
        })

    return clients[1]
end

function osi.sql.get_characters(client_id)
    local characters = MySQL.Sync.fetchAll('SELECT id, first_name, last_name, sex, dob, created FROM osi_character WHERE client_id=@client_id;', 
        {
        ['@client_id'] = client_id
        })
    return characters
end

function osi.sql.get_character_data(character_id)
    local characters = MySQL.Sync.fetchAll('SELECT id, first_name, last_name, sex, dob, created FROM osi_character WHERE id=@character_id;', 
        {
        ['@character_id'] = character_id
        })
    return characters[1]
end

function osi.sql.get_attribute_data(character_id)
    local attributes = MySQL.Sync.fetchAll('SELECT strength, dexterity, intelligence FROM osi_attributes WHERE character_id=@character_id;', 
        {
        ['@character_id'] = character_id
        })
    return attributes[1]
end

function osi.sql.get_money_data(character_id)
    local money = MySQL.Sync.fetchAll('SELECT cash, bank FROM osi_money WHERE character_id=@character_id;', 
        {
        ['@character_id'] = character_id
        })
    return money[1]
end

function osi.sql.delete_character(character_id)
    local result = MySQL.Sync.execute('DELETE FROM osi_character WHERE id=@character_id;', {
        ['@character_id'] = character_id
        })
end