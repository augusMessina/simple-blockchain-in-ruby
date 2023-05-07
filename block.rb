class Block
  attr_reader :index, :timestamp, :transactions, 
							:transactions_count, :previous_hash, 
							:nonce, :hash 

  # el bloque se inicializa con los parámetros, la fecha y hora,
  # y los valores de retorno de compute_hash_with_proof_of_work
  def initialize(index, transactions, previous_hash, minerIP=nil, timestamp=nil, nonce=nil, hash=nil)
    @index         		 	 = index
    @timestamp      	 	 = timestamp || Time.now
    @transactions 	 		 = transactions
		@transactions_count  = transactions.size
    @previous_hash 		 	 = previous_hash

    if (nonce and hash)
      @nonce = nonce
      @hash = hash
    else
      @nonce, @hash  		 	 = compute_hash_with_proof_of_work(minerIP || nil)
    end

  end

  # función de cálculo de los valores de hash y nonce.
  # Se inicia un bucle en el que se calcula un hash a partir
  # de un nonce inicial. Si el hash no cumple con la dificultad
  # propuesta, se intenta otra vez con un nonce distinto
	def compute_hash_with_proof_of_work(difficulty="00", minerIP)
		nonce = 0
		loop do 
			hash = calc_hash_with_nonce(nonce)
			if hash.start_with?(difficulty)

        # si la dificultad es satisfecha, se añade a las transacciones del bloque
        # una recompensa para el minero (si se tiene la IP de este) y se retornan
        # valores del hash y del nonce
        if minerIP
          @transactions << {
            from: "Blockchain Admin",
            to: minerIP,
            what: "Bitcoin",
            qty: 1
          }
        end
				return [nonce, hash]
			else
				nonce +=1
			end
		end
	end
	
  # función de cálculo del hash a partir del nonce pasado
  # como parámetro y el resto de atributos del bloque
  def calc_hash_with_nonce(nonce=0)
    sha = Digest::SHA256.new
    sha.update( nonce.to_s + 
								@index.to_s + 
								@timestamp.to_s + 
								@transactions.to_s + 
								@transactions_count.to_s +	
								@previous_hash )
    sha.hexdigest 
  end

  def self.first( *transactions )    # Create genesis block
    ## Uses index zero (0) and arbitrary previous_hash ("0")
    Block.new( 0, transactions, "0")
  end

  def self.next( previous, transactions, minerIP )
    Block.new( previous.index+1, transactions, previous.hash, minerIP )
  end

  def self.newCopiedBlock( block )
    Block.new( block['index'], block['transactions'], block['previous_hash'], nil, block['timestamp'], block['nonce'], block['hash'] )
  end

  # función que devuelve un hash a paritr de
  # los atributos del bloque
  def to_hash
    {
      index: @index,
      timestamp: @timestamp,
      transactions: @transactions,
      transactions_count: @transactions_count,
      previous_hash: @previous_hash,
      hash: @hash,
      nonce: @nonce
    }
  end
end  # class Block