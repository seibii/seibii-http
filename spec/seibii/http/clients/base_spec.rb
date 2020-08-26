require 'spec_helper'

RSpec.describe Seibii::Http::Clients::Base do
  describe '#request' do
    let(:headers) { { 'Accept' => '*/*', 'X-ORIGINAL-HEADER' => 'value' } }
    let(:request_body) { 'RequestBody' }
    let(:uri) { 'https://example.com/example' }
    let(:response) { double(:response) }
    let(:code) { 200 }

    before do
      allow(response).to receive(:code) { code }
      allow(response).to receive(:body) { 'ok' }
      expect_any_instance_of(Net::HTTP).to receive(:request) { response }
      allow_any_instance_of(method).to receive(:[]=)
      headers.each { |key, value| expect_any_instance_of(method).to receive(:[]=).with(key, value) }
      expect_any_instance_of(method).to receive(:body=).with(request_body)
    end

    subject do
      Seibii::Http::Clients::Base.new
        .request(method: method_sym, uri: uri, request_body: request_body, headers: headers)
    end

    context 'with HEAD method' do
      let(:method) { Net::HTTP::Head }
      let(:method_sym) { :head }
      it { is_expected.to eq 'ok' }
    end

    context 'with GET method' do
      let(:method) { Net::HTTP::Get }
      let(:method_sym) { :get }
      it { is_expected.to eq 'ok' }
    end

    context 'with POST method' do
      let(:method) { Net::HTTP::Post }
      let(:method_sym) { :post }
      it { is_expected.to eq 'ok' }
    end

    context 'with PATCH method' do
      let(:method) { Net::HTTP::Patch }
      let(:method_sym) { :patch }
      it { is_expected.to eq 'ok' }
    end

    context 'with PUT method' do
      let(:method) { Net::HTTP::Put }
      let(:method_sym) { :put }
      it { is_expected.to eq 'ok' }
    end

    context 'with DELETE method' do
      let(:method) { Net::HTTP::Delete }
      let(:method_sym) { :delete }
      it { is_expected.to eq 'ok' }
    end

    context 'when receives error response' do
      context 'with 404 response' do
        let(:method) { Net::HTTP::Get }
        let(:method_sym) { :get }
        before { allow(response).to receive(:code) { 404 } }

        it { is_expected.to be_nil }
      end

      context 'with 400 response' do
        let(:method) { Net::HTTP::Get }
        let(:method_sym) { :get }
        before { allow(response).to receive(:code) { 400 } }

        it 'should raise client error' do
          expect { subject }.to raise_error(Seibii::Http::ClientError)
        end
      end

      context 'with 500 response' do
        let(:method) { Net::HTTP::Get }
        let(:method_sym) { :get }
        before { allow(response).to receive(:code) { 500 } }

        it 'should raise client error' do
          expect { subject }.to raise_error(Seibii::Http::ServerError)
        end
      end
    end
  end
end
