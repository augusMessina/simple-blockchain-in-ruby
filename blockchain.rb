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
require 'digest/md5'
require 'sinatra'
require 'securerandom'

LEDGER = []
$blockIndex = 1

#####
## Blockchain building, one block at a time.
##  This will create a first block with fake transactions
## 	and then prompt user for transactions informations and set it in a new block.
## 	
## Each block can take multiple transaction
## 	when a user has finish to add transaction, 
##  the block is added to the blockchain and writen in the ledger


def create_first_block
	instance_variable_set( "@b#{0}", 
		Block.first( 
			{ from: "Dutchgrown", to: "Vincent", what: "Tulip Bloemendaal Sunset", qty: 10 },
			{ from: "Keukenhof", to: "Anne", what: "Tulip Semper Augustus", qty: 7 }
		)
	)
	LEDGER << @b0
	
	
end
	
	
	
def add_block(transactions)
	instance_variable_set("@b#{$blockIndex}", Block.next( LEDGER.last, transactions))
	LEDGER << instance_variable_get("@b#{$blockIndex}")

	$blockIndex += 1
	
end

def launcher
	puts "==========================="
	puts ""
	puts "Welcome to Simple Blockchain In Ruby !"
	puts ""
	sleep 1.5
	puts "This program was created by Anthony Amar for and educationnal purpose"
	puts ""
	sleep 1.5
	puts "Wait for the genesis (the first block of the blockchain)"
	puts ""
	for i in 1..10
		print "."
		sleep 0.5
		break if i == 10
	end
	puts "" 
	puts "" 
	puts "==========================="
	create_first_block
end

create_first_block

get '/chain' do
	content_type :json
	blocks = LEDGER.map(&:to_hash)

	response = {
		chain: blocks
	}
	status 200
	response.to_json
end

post '/newBlock' do
	content_type :json
	values = JSON.parse(request.body.read)
	return status 404 unless values['transactions']
  
	# Create a new Block
	add_block(values['transactions'])

	blocks = LEDGER.map(&:to_hash)

	response = {
		message: "New block added",
		block: blocks.last 
	}

	status 201
	response.to_json
  end
