class CreateReclamantes < ActiveRecord::Migration
  def self.up
    create_table :reclamantes do |t|
      t.float :Numero_Ordem
      t.integer :Sequencial
      t.string :Nome_Reclamante
      t.string :Data_Nascimento
      t.string :Nome_Mae
      t.string :Nome_Pai
      t.string :Endereco
      t.string :Complemento
      t.string :Bairro
      t.string :Cidade
      t.string :CEP
      t.string :UF
      t.string :matricula
      t.float :Codigo_Funcao
      t.string :Lotacao
      t.string :CTPS
      t.string :serie
      t.string :UF_CTPS
      t.string :Local_trabalhado
      t.date :periodo_inicial1
      t.date :periodo_final1
      t.date :periodo_inicial2
      t.date :periodo_final2
      t.date :periodo_inicial3
      t.date :periodo_final3
      t.date :periodo_inicial4
      t.date :periodo_final4

      t.timestamps
    end
  end

  def self.down
    drop_table :reclamantes
  end
end
