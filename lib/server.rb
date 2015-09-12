#!/usr/bin/env ruby
#vim:ts=4:sw=4:et:
class CPU
    attr_accessor :smth, :hz, :cores,:generation
    def initialize(smth, hz, cores, generation)
        @smth = smth
        @hz = hz
        @cores = cores
        @generation = generation
    end

    def == (cpu2)
        if hz == cpu2.hz && cores == cpu2.cores && generation == cpu2.generation then
            return true
        end
        return false
    end
    def to_s
        return "smth:#{smth}, hz:#{hz}, cores:#{cores}, generation:#{generation}"
    end
end

class Memory
    attr_accessor :type, :size
    def initialize(type, size)
        @type = type
        @size = size
    end

    def == (mem2)
        if type == mem2.type && size == mem2.size then
            return true
        end
        return false
    end
end

class Server
    def initialize()
        @cpu_slots_max = 2
        @cpu_slots = [] #array of CPU class objects
        @memory_banks_max = 16
        @memory_banks = []  #this is crappy, fucking crappy definition of array without elements type like Array(Memory)
                            #making the reader guess what the hell going to be inside the array
                            #so, making it clear with comment - this gonna hold Memory class objects
        @supported_cpu_generation = 3
        @supported_memory_type = :ddr4
    end

    #memory part
    def add_memory(bank)
        needclass="Memory"
        if bank.class.to_s != needclass then
            raise "provided value is not #{needclass}"
        end
        if bank.type != @supported_memory_type then
            raise "unsupported memory type #{bank.type}"
        end
        if @memory_banks.length + 1 > @memory_banks_max then
            raise "not enoght memory banks for this server (max is #{@memory_banks_max}"
        end
        @memory_banks.push(bank)
    end
    def memory_size
        size=0
        @memory_banks.each do | n |
            size=size+n.size
        end
        return size
    end


    #cpu part
    def add_cpu(cpu)
        needclass="CPU"
        if cpu.class.to_s != needclass then
            raise "provided value is not #{needclass}"
        end
        if cpu.generation != @supported_cpu_generation then
            raise "unsupported CPU generation #{cpu.generation}"
        end
        if cpus_count + 1 > @cpu_slots_max then
            raise "too much CPUs for this server type (max is #{@cpu_slots_max}"
        end
        @cpu_slots.each do | c |
            if c == cpu then
                #pass
            else
                raise "you are trying to add cpu which differs from the ones server has #{@cpu}"
            end
        end
        @cpu_slots.push(cpu)
    end

    def cpus_count
        count=0
        @cpu_slots.each do | n |
            count=count + 1
        end
        return count
    end
    def bootable?
        bootable = memory_size > 0 && cpus_count > 0
        return bootable
    end
end
