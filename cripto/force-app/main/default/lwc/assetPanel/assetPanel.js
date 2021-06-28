import { LightningElement, wire } from 'lwc';
import getPrice from '@salesforce/apex/BinanceApi.getPrice';
import getPriceFiltered from '@salesforce/apex/BinanceApi.getPriceFiltered';

const columns = [
    { label: 'Ativo', fieldName: 'symbol', type: 'text' },
    { label: 'Preço', fieldName: 'price', type: 'text' }
];

export default class AssetPanel extends LightningElement {
    data = [];
    columns = columns;
    searchKey = '';
    isLoading = true;

    @wire(getPrice, {}) setData({ error, data }) {
        this.isLoading = true;
        if (error) {
            console.error(error);
            this.isLoading = false;
        } else {
            if (data) {
                this.data = data;
                this.isLoading = false;
            }
        }
    }

    @wire(getPriceFiltered, { searchKey: "$searchKey" }) setDataFilter({ error, data }) {
        if (error) {
            console.error(error);
            this.isLoading = false;
        } else {
            if (data) {
                this.data = data;
                this.isLoading = false;
            }
        }
    }

    handleKeyChange(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.isLoading = true;
            this.searchKey = searchKey;
        }, 1000);
    }
}