require "track_seats_ruby/version"

module TrackSeatsRuby
  class Error < StandardError; end
  # Your code goes here...
  class TrackSeat
	def self.best_seat(rows, columns,seats,number_of_seats)
		seats_from_center = TrackSeat.find_best_seat(rows,columns)
    avail_seats = TrackSeat.get_seats(seats)
    response = TrackSeat.get_best_seats(seats_from_center,avail_seats,number_of_seats)
 		return response
	end


 	def self.get_seats(seats)
		seats.values.map{|i| i["id"] if i["status"] === "AVAILABLE" }
	end

  def self.seats_map
	  obj = {}
	 ("A".."Z").map.with_index do |char, index|
	 	obj[index+1] = char
	 end
	 return obj
  end

  def self.find_best_seat(row, column)
  	hash = {}
  	@pos = 1
    (1..row).each do |value|
    	center_column = (column/2).ceil
    	self.no_of_seats(3,hash,center_column,value)
    end
    return hash
  end

  def self.get_best_seats(seats_from_center,avail_seats,number)

    before_seat = ''
    after_seat = ''
    # limit refer to number of seats requested
    limit = number.to_i
    result = []
    sorted_seats = avail_seats.sort
    sorted_seats.each do |seat|
      
      if seats_from_center.has_value?(seat)
				unless result.include?(seat)
				  if result.size < limit
				    result.push(seat)
				  end
				end   

				1.times do |i|
          
				  before_seat = seat[0] + ((seat[1,seat.size].to_i)-1).to_s
				  if  sorted_seats.include?(before_seat)
						unless result.include?(before_seat)
						  if result.size < limit
						      result.push(before_seat)
						      
						  end
						end
				  end
				end
        1.times do |i|
          after_seat = seat[0] + ((seat[1,seat.size].to_i)+1).to_s
          if  sorted_seats.include?(after_seat)
              unless result.include?(after_seat)
                  if result.size < limit
                      result.push(after_seat)
                      
                  end
              end
          end
        end  
      end  
    end
    closer_to_ref=''
    aux = []
    seats_from_center_parameter = seats_from_center[1][1,seats_from_center[1].size].to_i
    closer_to_ref_integer = seats_from_center_parameter
    seats_from_center.each do |key, value|
      avail_seats.each do |seat|
      
          if seats_from_center[key].include?(seat[0])
              if (closer_to_ref_integer > (seats_from_center_parameter - seat[1,seat.size].to_i).abs()) 
                  aux.push(seat)
                  closer_to_ref = seat
                  closer_to_ref_integer = (seats_from_center_parameter - seat[1,seat.size].to_i).abs()
                  
                  
              end
              
          end 
      end
    end
    
    while result.size < limit do
	    unless result.include?(aux.last) && aux.size > 0
	      if result.size < limit
          result.push(aux.last)
          aux.pop()
	      end
	    end
    end
    return result.sort
  end
  def self.no_of_seats(val,hash,center_column,value)
  	(1..val).each do |d|
			1.times do |i|
			  hash[@pos] = TrackSeat.seats_map[value].downcase.concat(center_column.to_s)
			  cal = d == 1 ? 1 : (d == 2 ? -2 : 2)
			  center_column+= cal
			end
	    @pos+=1
  	end
  end
end
end
