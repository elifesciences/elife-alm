# encoding: UTF-8

# $HeadURL$
# $Id$
#
# Copyright (c) 2009-2014 by Public Library of Science, a non-profit corporation
# http://www.plos.org/
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'timeout'

class QueueJob < Struct.new(:source_id)

  def perform
    source = Source.find(source_id)
    return 0 if source.inactive?

    Timeout.timeout(5.minutes) do
      source.queue_stale_articles
    end
  rescue Timeout::Error
    source = Source.find(source_id)
    Alert.create(:exception => "",
                 :class_name => "Timeout::Error",
                 :message => "QueueJob timeout error for #{source.display_name}",
                 :status => 408,
                 :source_id => source.id)
  end

  def error(job, e)
    source = Source.find(source_id)
    Alert.create(:exception => e, :message => "#{e.message} in #{job.queue}", :source_id => source.id)
  end

  def after(job)
    source = Source.find(source_id)
    source.add_queue(source.run_at + source.batch_time_interval)
  end

end
