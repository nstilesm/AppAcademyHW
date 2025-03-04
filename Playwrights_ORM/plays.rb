require 'sqlite3'
require 'singleton'

class PlayDBConnection < SQLite3::Database
  include Singleton

  def initialize
    super('plays.db')
    self.type_translation = true
    self.results_as_hash = true
  end
end

class Play
  attr_accessor :id, :title, :year, :playwright_id

  def self.find_by_title(title)
    play = PlayDBConnection.instance.execute(<<-SQL, title)
    SELECT 
      *
    FROM
      plays
    WHERE
      title = ?
    SQL
    if play.length < 1
      return nil
    else 
      Play.new(play.first)
    end
  end

  def self.find_by_playwright(name)
    playwright = Playwright.find_by_name(name)
    raise "#{name} not found in db" unless playwright
    play = PlayDBConnection.instance.execute(<<-SQL, playwright.id)
    SELECT 
      *
    FROM
      plays
    WHERE
      playwright.id = ?
    SQL
    play.map { |playwright| Play.new(playwright)}

  end

  def self.all
    data = PlayDBConnection.instance.execute("SELECT * FROM plays")
    data.map { |datum| Play.new(datum) }
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @year = options['year']
    @playwright_id = options['playwright_id']
  end

  def create
    raise "#{self} already in database" if self.id
    PlayDBConnection.instance.execute(<<-SQL, self.title, self.year, self.playwright_id)
      INSERT INTO
        plays (title, year, playwright_id)
      VALUES
        (?, ?, ?)
    SQL
    self.id = PlayDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless self.id
    PlayDBConnection.instance.execute(<<-SQL, self.title, self.year, self.playwright_id, self.id)
      UPDATE
        plays
      SET
        title = ?, year = ?, playwright_id = ?
      WHERE
        id = ?
    SQL
  end
end


class Playwright

  attr_accessor :id, :name, :birth_year

  def self.all
    data = PlayDBConnection.instance.execute("SELECT * FROM playwrights")
    data.map { |datum| Playwright.new(datum)}
  end

  def self.find_by_name(name)
    actors = PlayDBConnection.instance.execute(<<-SQL, name)
    SELECT
      *
    FROM
      playwrights
    WHERE
      name = ?
    SQL
    if person.length < 1
      return nil
    else
      Playwright.new(actors.first)
    end

  end
  
  def initialize(options)
    @id = options['id']
    @name = options['name']
    @birth_year = options['birth_year']
  end


  def insert
    raise "#{self} in database" if self.id
    PlayDBConnection.instance.execute(<<-SQL, self.name, self.birth_year)
    INSERT INTO
      playwrights (name, birth_year)
    VALUES
      (?, ?)
    SQL
    self.id = PlayDBConnection.instance.last_insert_row_id
  end

  def update
    raise "#{self} not in database" unless self.id
    PlayDBConnection.instance.execute(<<-SQL, self.name, self.birth_year)
    UPDATE
      playwrights
    SET 
      name = ?, birth_year = ?
    WHERE
      id = ?
    SQL
  end

  def get_plays
    raise "#{self} not in database" unless self.id
    playwright = PlayDBConnection.instance.execute(<<-SQL, self.id)
    SELECT
      *
    FROM
      playwright
    WHERE
      playwright_id = ?
    SQL
    playwright.map {|play| Play.new(play)}
  
  end
end