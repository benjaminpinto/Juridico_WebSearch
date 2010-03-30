# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090716022252) do

  create_table "reclamantes", :force => true do |t|
    t.float    "Numero_Ordem"
    t.integer  "Sequencial"
    t.string   "Nome_Reclamante"
    t.string   "Data_Nascimento"
    t.string   "Nome_Mae"
    t.string   "Nome_Pai"
    t.string   "Endereco"
    t.string   "Complemento"
    t.string   "Bairro"
    t.string   "Cidade"
    t.string   "CEP"
    t.string   "UF"
    t.string   "matricula"
    t.float    "Codigo_Funcao"
    t.string   "Lotacao"
    t.string   "CTPS"
    t.string   "serie"
    t.string   "UF_CTPS"
    t.string   "Local_trabalhado"
    t.date     "periodo_inicial1"
    t.date     "periodo_final1"
    t.date     "periodo_inicial2"
    t.date     "periodo_final2"
    t.date     "periodo_inicial3"
    t.date     "periodo_final3"
    t.date     "periodo_inicial4"
    t.date     "periodo_final4"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
