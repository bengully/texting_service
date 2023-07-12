class LoadBalancer
    class << self
        def reset_providers
            $redis.set('provider1', 0)
            $redis.set('provider2', 0)
        end

        def check_load(light_load:, heavy_load:)
            # Add 1 to each to figure out what percentage the incoming change would make.
            if (provider2+1)/(total+1) > 0.7
                $redis.incr('provider1')
                return light_load
            else
                $redis.incr('provider2')
                return heavy_load
            end
        end

        private

        def total
            provider1 + provider2
        end

        def provider1
            $redis.get('provider1').to_f
        end

        def provider2
            $redis.get('provider2').to_f
        end
    end
end