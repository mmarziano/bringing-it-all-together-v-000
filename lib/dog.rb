class Dog 
  attr_accessor :name, :breed
  attr_reader :id 
  
  def initialize(name:, breed:, id:nil )
    @id = id
    @name = name
    @breed = breed
  end 
  
  def self.create_table 
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
        id INTEGER PRIMARY KEY,
        name TEXT,
        breed TEXT
      )
      SQL
      
      DB[:conn].execute(sql)
  end 
  
  def self.drop_table 
    sql = <<-SQL
      DROP TABLE IF EXISTS dogs 
      SQL
      
      DB[:conn].execute(sql)
  end 
  
  def save
    sql = <<-SQL
      INSERT INTO dogs 
      (name, breed) 
      VALUES (?,?)
    SQL
     
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    self
  end 
  
  def self.create(attributes) 
    name = attributes[:name]
    breed = attributes[:breed]
    new_dog = Dog.new(name: name, breed: breed)
    new_dog.save
    new_dog
  end 
  
  def self.find_by_id(id)
    sql = <<-SQL 
      SELECT * FROM dogs 
      WHERE id = ?
      LIMIT 1 
    SQL
    
    dog = DB[:conn].execute(sql, id).flatten
    new_dog = Dog.new(name: dog[1], breed: dog[2], id: dog[0])
    new_dog
  end 
  
  def self.find_or_create_by(dog) 
     if dog[:id] != nil 
       self.find_by_id(dog.id)
      else 
        self.create(dog)
      end
    
  end 
  
  def self.new_from_db 
    
  end 
  
  def self.find_by_name(name) 
    sql = <<-SQL 
      SELECT * FROM dogs
      WHERE name = ? 
    SQL
    
    DB[:conn].execute(sql, name).flatten
  end 
  
  def self.update 
    
  end 
    
    
  
end 