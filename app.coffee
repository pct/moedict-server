# modules 
_ = require 'underscore'
express = require 'express'
Sequelize = require 'sequelize'

# Sequelize

sql = new Sequelize 'database', 'username', 'password'
    dialect: 'sqlite'
    storage: './db.sqlite3'
    logging: off
    define:
      underscored: on
      timestamps: off

# model
Definition = sql.define 'definitions',
    id: Sequelize.INTEGER
    heteronym_id: Sequelize.INTEGER
    type: Sequelize.STRING
    def: Sequelize.STRING
    example: Sequelize.STRING
    synonyms: Sequelize.STRING
    antonyms: Sequelize.STRING
    link_type: Sequelize.STRING
    link_id: Sequelize.INTEGER
    source: Sequelize.STRING
   
Dict = sql.define 'dicts',
    id: Sequelize.INTEGER
    name: Sequelize.STRING
    type: Sequelize.INTEGER

Entry = sql.define 'entries',
    id: Sequelize.INTEGER
    title: Sequelize.STRING
    radical: Sequelize.STRING
    stroke_count: Sequelize.INTEGER
    non_radical_stroke_count: Sequelize.INTEGER
    dict_id: Sequelize.INTEGER

Heteronym = sql.define 'heteronyms',
    id: Sequelize.INTEGER
    entry_id: Sequelize.INTEGER
    bopomofo: Sequelize.STRING
    bopomofo2: Sequelize.STRING
    pinyin: Sequelize.STRING


Dict.hasMany Entry, foreignKey: 'dict_id'
Entry.hasMany Heteronym, foreignKey: 'entry_id'
Heteronym.hasMany Definition, foreignKey: 'heteronym_id'

# app
app = express()

app.get '/', (req, res) ->
    res.send 'GET: /s/萌'

app.get '/s/:q', (req, res) ->
    if req.params['q']
        q = req.params['q']
        _entries = []

        Entry.findAll(where: "title like '#{q}%'").done (err, entries) ->
            if entries.length > 0
                _.each entries, (entry, e_num) ->
                    delete entry.selectedValues['created_at']
                    delete entry.selectedValues['updated_at']
                    _entries[e_num] = entry.selectedValues
                    entry.getHeteronyms().success (heteronyms) ->
                        _heteronyms = []
                        if heteronyms.length > 0
                            _.each heteronyms, (heteronym, h_num) ->
                                delete heteronym.selectedValues['created_at']
                                delete heteronym.selectedValues['updated_at']
                                _heteronyms[h_num] = heteronym.selectedValues
                                _entries[e_num]['heteronyms'] = _heteronyms
                                heteronym.getDefinitions().success (definitions) ->
                                    _definitions = []
                                    if definitions.length > 0
                                        _.each definitions, (definition, d_num) ->
                                            delete definition.selectedValues['created_at']
                                            delete definition.selectedValues['updated_at']
                                            _definitions[d_num] = definition.selectedValues
                                            _entries[e_num]['heteronyms'][h_num]['definitions'] = _definitions
                                    res.send JSON.stringify(_entries)
                        else
                            res.send JSON.stringify(_entries)
            else
                res.send JSON.stringify(_entries)
        

app.listen '3000'
