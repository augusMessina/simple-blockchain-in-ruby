###########################
#	Improved version of "Build your own blockchain from scratch in 20 lines of Ruby!"	
#		from https://github.com/openblockchains/awesome-blockchains/tree/master/blockchain.rb
#  
#   and inspired by
#     Let's Build the Tiniest Blockchain In Less Than 50 Lines of Python by Gerald Nash
#     see https://medium.com/crypto-currently/lets-build-the-tiniest-blockchain-e70965a248b
#
#	Now, Blockchain with prompt transactions, transactions counter for each block, 
#											 ledger, proof of work and dynamic variable name. 
#
#	This Blockchain can be set as a loop for infinite using of the Blockchain.
#
#
#  to run use:
#    $ ruby ./blockchain.rb
#
#
#

require 'digest'    							# For hash checksum digest function SHA256
require 'pp'        							# For pp => pretty printer
# require 'pry'                     # For on the fly debugging
require_relative 'block'					# class Block
require_relative 'transaction'		# method 

### requires añadidos ###
require 'json'
require 'sinatra'
require 'net/http'
require 'uri'

# en caso de querer permitir el acceso desde otros nodos
# en la misma red, deberá descomentar la línea de abajo
# e introducir la IP de su máquina
#set :bind, 'tu ip'

# en LEDGER se guarda la referencia de cada bloque en orden
LEDGER = []

# en este array se guardarán las transacciones pendientes
# de ser guardadas en un bloque
$pending_transactions = []

# en este array se guardarán las IPs de los nodos
$nodes = []

# esta variable marcará el index de cada bloque
$blockIndex = 1

#####
## Blockchain building, one block at a time.
##  This will create a first block with fake transactions
## 	and then prompt user for transactions informations and set it in a new block.
## 	
## Each block can take multiple transaction
## 	when a user has finish to add transaction, 
##  the block is added to the blockchain and writen in the ledger

# creación del bloque génesis
def create_first_block
	instance_variable_set( "@b#{0}", 
		Block.first( 
			{ from: "Dutchgrown", to: "Vincent", what: "Tulip Bloemendaal Sunset", qty: 10 },
			{ from: "Keukenhof", to: "Anne", what: "Tulip Semper Augustus", qty: 7 }
		)
	)
	LEDGER << @b0
end

# con la siguiente función se crea un nuevo bloque, a partir de las transacciones,
# la referencia del bloque anterior, y la IP del minero, que se utilizará para
# grabar una recompensa en las transacciones
def mine_block(minerIP)
	instance_variable_set("@b#{$blockIndex}", Block.next( LEDGER.last, $pending_transactions, minerIP))
	LEDGER << instance_variable_get("@b#{$blockIndex}")
	$blockIndex += 1

	# las transacciones pendientes se eliminan al crear un bloque
	$pending_transactions = []
end

#
def resolve_nodes
	for node in $nodes do
		response = JSON.parse(Net::HTTP.get(URI.parse("http://#{node}/chain")))

		length = response['chain'].length()
		chain = response['chain']

		# Si la cadena recibida es más larga que la cadena propia,
		# se considerará como una cadena más actualizada, y por
		# lo tanto se actualizará la propia a ella
		if length > LEDGER.length()
			max_length = length
			new_chain = chain
		end
		
	end
	
	if new_chain
		LEDGER.clear()
		$blockIndex = 0
		for block in new_chain do
			instance_variable_set("@b#{$blockIndex}", Block.newCopiedBlock(block))
			LEDGER << instance_variable_get("@b#{$blockIndex}")
		end
		return true
	end

	return false
end

create_first_block

# aquí comienza la declaración de endpoints para el servidor de sinatra

# endpoint GET que devuelve toda la cadena
get '/chain' do
	content_type :json

	# con el método 'map' sustituimos cada valor del array
	# por otro, en este caso, se sustituirá por lo que devuelve
	# el método 'to_hash' de la clase Block
	blocks = LEDGER.map(&:to_hash)

	response = {
		chain: blocks
	}
	status 200
	response.to_json
end

# endpoint GET que devuelve las transacciones pendientes
get '/transactions' do
	content_type :json

	response = {
		pending_transactions: $pending_transactions
	}
	status 200
	response.to_json
end

# endpoint POST que añade transacciones al array de pendientes
post '/newTransaction' do
	content_type :json

	values = JSON.parse(request.body.read)

	# en caso de no haber pasado los parámetros adecuados, se devuelve status 400 (Bad Request)
	return status 400 unless (values['from'] and values['to'] and values['what'] and values['qty'])

	$pending_transactions << {
		from: values['from'],
		to: values['to'],
		what: values['what'],
		qrt: values['qty']
	}

	response = {
		message: "Transaction added succesfully",
		transaction: $pending_transactions.last
	}
	status 200
	response.to_json
end

# endpoint POST que añade bloques a la cadena, llamando a la función mine_block
# y pasando la IP recibida
post '/mine' do
	content_type :json

	# si no hay transacciones pendientes, se devuelve status 500 (Service Unavailable)
	if $pending_transactions.length() == 0
		response = {
			message: "No transactions available to mine a block"
		}
		status 503
		return
	end

	resolve_nodes

	mine_block(request.ip)

	blocks = LEDGER.map(&:to_hash)

	# devuelve el bloque añadido
	response = {
		message: "New block mined",
		block: blocks.last 
	}

	status 200
	response.to_json
end

# los siguientes endpoints permiten un sistema descentralizado

post '/nodes/register' do
	content_type :json

	values = JSON.parse(request.body.read)

	# en caso de no haber pasado los parámetros adecuados, se devuelve status 400 (Bad Request)
	return status 400 unless values['nodes']

	for node in values['nodes']
		# se añade cada nodo a la cadena
		# en caso de que ya exista, no se añade
		# ya que el método '<<' no añade duplicados
		$nodes << node
	end

	response = {
		message: "Nodes added",
		nodes: $nodes
	}
	status 200
	response.to_json
end

# endpoint GET que devuelve todos los nodos de la cadena
get '/nodes/resolve' do
	content_type :json



	# se llama a la fución 'resolve_nodes', que compara
	# la cadena de este nodo con la del resto
	if resolve_nodes
		response = {
			message: "Chain was updated."
		}
		status 200
		response.to_json
	else
		response = {
			message: "Chain was not updated"
		}
		status 500
		response.to_json
	end
end