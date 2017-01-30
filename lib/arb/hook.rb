require "arb/hook/version"

module Arb
  module Hook
    #"Clean" Room
    BasicObject.new.instance_eval do

      hook_prefix = '_arb_hook_'

      Module.send :define_method,:hook_methods do |regex=nil,&blk|
      blk = blk || Proc.new do |method_name,*args,&block|
        puts "#{method_name}(#{args.map(&:inspect).join(',')}) #{block}"
      end
      class_eval do 
        [].tap do |hooked|
          %i{private_instance protected_instance instance}.each do |prefix|
            send("#{prefix}_methods")
            .select{|method| instance_method(method).owner == self}
            .map(&:to_s)
            .select{|method| !method.start_with?(hook_prefix)}
            .grep(regex || // ) do |target_method|
              unhook_method target_method
              alias_method hook_prefix+target_method,target_method
              define_method target_method do |*args,&block|
                blk[target_method,*args,&block]
                method("_arb_hook_#{target_method}")[*args,&block]
              end
              hooked<<target_method
            end
          end
        end
      end
      end


      Module.send :define_method,:hook_method do |name,&blk|
        proxy_block = blk && Proc.new do |method,*args,&block|
          blk[*args,&blk]
        end
        hook_methods(/^#{Regexp.escape(name.to_s)}$/,&proxy_block).size>0
      end


      Module.send :define_method,:hooked_methods do
        [].tap do  |hooked|
          %i{private_instance protected_instance instance}.each do |prefix|
            hooked<<send("#{prefix}_methods")
            .map(&:to_s)
            .select{|method| (instance_method(hook_prefix+method) rescue nil)}
            .to_a
          end
          hooked.flatten!
        end
      end

      Module.send :define_method,:unhook_method do |name|
        if target_method=(instance_method(hook_prefix+name.to_s).name.to_s rescue nil)
          alias_method target_method[(hook_prefix.length)..-1],target_method
          return true if (undef_method(target_method) rescue nil)
        end
        false
      end

      Module.send :define_method,:unhook_methods do |regex=nil|
      [].tap do |unhooked|
        hooked_methods.grep(regex || //).each do |method|
          unhooked<<method if unhook_method(method)
        end
      end
      end


    end
  end
end
