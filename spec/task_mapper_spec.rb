require 'spec_helper'

RSpec.describe TaskMapper do

  let(:tt_tasks) {
    [
      { id: 1, name: "#01 SEO", have_used: false, project: {id: 2, name: "#01 SEO", customer: {id: 3, name: "#01 SEO"}} },
      { id: 4, name: "#01 SEO Blah", have_used: false, project: {id: 5, name: "#01 SEO", customer: {id: 6, name: "#01 SEO"}} },
      { id: 7, name: "#02 General Admin", have_used: true, num_users: 5, project: {id: 8, name: "#02 General Admin", customer: {id: 9, name: "#02 General Admin"}} },
      { id: 10, name: "#03 General Admin", have_used: false, num_users: 50, project: {id: 11, name: "#03 General Admin", customer: {id: 12, name: "#03 General Admin"}} },
      { id: 13, name: "#04 Unified", have_used: false, num_users: 50, project: {id: 14, name: "#04 Unified", customer: {id: 15, name: "#04 Unified"}} },
      { id: 16, name: "#05 Reporting", have_used: false, num_users: 5, project: {id: 17, name: "#05 Big Engineering", customer: {id: 18, name: "#05 Big Engineering"}} },
      { id: 19, name: "#06 Reporting", have_used: false, num_users: 50, project: {id: 20, name: "#06 Small Engineering", customer: {id: 21, name: "#06 Small Engineering"}} }
    ].map do |data|

      project = nil
      customer = nil

      if data[:project]
        if data[:project][:customer]
          customer = TrackingTime::Customer.new(id: data[:project][:customer][:id], name: data[:project][:customer][:name])
        end
        project = TrackingTime::Project.new(id: data[:project][:id], name: data[:project][:name], customer: customer)
      end

      TrackingTime::Task.new(id: data[:id], name: data[:name], have_used: data[:have_used], num_users: data[:num_users], project: project)
    end
  }

  let(:instance) { described_class.new(tracking_time_tasks: tt_tasks) }

  it 'picks the most used matching task' do
  end

  it 'does not care about case when matching task' do
    expect_matching_task_id("unified", 13)
  end

  it 'picks the task matching the project or customer when only has number' do
  end

  def expect_no_matching_task(value)
    matching_task = instance.best_tracking_time_task_for(value)
    expect(matching_task).to be_nil
  end

  def expect_matching_task_id(value, id)
    matching_task = instance.best_tracking_time_task_for(value)
    expect(matching_task).not_to be_nil
    expect(matching_task.id).to eq id
  end

end
