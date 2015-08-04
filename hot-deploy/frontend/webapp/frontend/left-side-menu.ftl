<#--
        Licensed to the Apache Software Foundation (ASF) under one
        or more contributor license agreements.  See the NOTICE file
        distributed with this work for additional information
        regarding copyright ownership.  The ASF licenses this file
        to you under the Apache License, Version 2.0 (the
        "License"); you may not use this file except in compliance
        with the License.  You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

        Unless required by applicable law or agreed to in writing,
        software distributed under the License is distributed on an
        "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
        KIND, either express or implied.  See the License for the
        specific language governing permissions and limitations
        under the License.
        -->
            <h4>Raccourcis</h4>
            <div class="ruler"></div>
            <ul class="shortcut-glyph-list">
                <li class="shortcut-glyph text-center color-purple">
                    <a href="#"><i class="fa fa-shopping-cart fa-2x"></i></a>
                </li>
                <li class="shortcut-glyph text-center color-orange">
                    <a href="#"><i class="fa fa-map-marker fa-2x"></i></a>
                </li>
                <li class="shortcut-glyph text-center color-dark-blue">
                    <a href="#"><i class="fa fa-search fa-2x"></i></a>
                </li>
                <li class="shortcut-glyph text-center color-blue">
                    <a href="#"><img class="img-responsive center-block" src="<@ofbizContentUrl>/frontend/images/map-france.svg</@ofbizContentUrl>"></a>
                </li>
                <li class="shortcut-glyph text-center color-green">
                    <a href="#"><img class="img-responsive center-block" src="<@ofbizContentUrl>/frontend/images/bio.svg</@ofbizContentUrl>"></a>
                </li>
            </ul>
            <div style="height:100px"></div>
            <h4>Catégories</h4>
            <div class="ruler"></div>
            <ul class="categorie-list">
                <li><i class="fa fa-angle-right"></i><a href="#">PGC</a></li>
            </ul>
            <div style="height:10px"></div>
            <h4>Ordre de prix</h4>
            <div class="ruler"></div>
            <div>
                <div>
                    <input type="text" id="range" value="" name="range" />
                </div>
            </div>
            <div style="height:10px"></div>
            <h4>Filtres</h4>
            <div class="ruler"></div>
            <nav>
                <ul class="nav nav-pills nav-stacked span2 filter-menu">
                    <li>
                        <a href="#additif-list" data-toggle="collapse" aria-expanded="false" aria-controls="additif-list"><i class="fa fa-angle-right"></i> Additifs</a>
                        <ul class="filter-checkbox-menu collapse" id="additif-list">
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Indéfini (3)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Sans additif (2)
                                </label>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#aromes-list" data-toggle="collapse" aria-expanded="false" aria-controls="additif-list"><i class="fa fa-angle-right"></i> Arômes</a>
                        <ul class="filter-checkbox-menu collapse" id="aromes-list">
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Indéfini (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Cranberry pomme framboise (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Ananas (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Banane (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Orange carotte citron (1)
                                </label>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#autre-molecules-list" data-toggle="collapse" aria-expanded="false" aria-controls="additif-list"><i class="fa fa-angle-right"></i> Autres Molécules</a>
                        <ul class="filter-checkbox-menu collapse" id="autre-molecules-list">
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Indéfini (4)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Béta carotène (1)
                                </label>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#biologique-list" data-toggle="collapse" aria-expanded="false" aria-controls="additif-list"><i class="fa fa-angle-right"></i> Biologique</a>
                        <ul class="filter-checkbox-menu collapse" id="biologique-list">
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Indéfini (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Biologique (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Non-bio (3)
                                </label>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#bouchon-list" data-toggle="collapse" aria-expanded="false" aria-controls="additif-list"><i class="fa fa-angle-right"></i> Bouchon</a>
                        <ul class="filter-checkbox-menu collapse" id="bouchon-list">
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Capsule (3)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> À vis (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Indéfini (1)
                                </label>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#colorant-list" data-toggle="collapse" aria-expanded="false" aria-controls="additif-list"><i class="fa fa-angle-right"></i> Colorant</a>
                        <ul class="filter-checkbox-menu collapse" id="colorant-list">
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Indéfini (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Sans colorants (4)
                                </label>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#conservateur-list" data-toggle="collapse" aria-expanded="false" aria-controls="additif-list"><i class="fa fa-angle-right"></i> Conservateur</a>
                        <ul class="filter-checkbox-menu collapse" id="conservateur-list">
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Indéfini (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Sans conservateurs (4)
                                </label>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#conservation-list" data-toggle="collapse" aria-expanded="false" aria-controls="additif-list"><i class="fa fa-angle-right"></i> Conservation</a>
                        <ul class="filter-checkbox-menu collapse" id="conservation-list">
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Indéfini (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Air ambiant (4)
                                </label>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#conservation-ouverture-list" data-toggle="collapse" aria-expanded="false" aria-controls="additif-list"><i class="fa fa-angle-right"></i> Conservation après ouverture</a>
                        <ul class="filter-checkbox-menu collapse" id="conservation-ouverture-list">
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Indéfini (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> De 5 à 6 °C (4)
                                </label>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#contenant-list" data-toggle="collapse" aria-expanded="false" aria-controls="additif-list"><i class="fa fa-angle-right"></i> Contenant</a>
                        <ul class="filter-checkbox-menu collapse" id="contenant-list">
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Verre (4)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Indéfini (1)
                                </label>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Flash pasteurisation (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Indéfini (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Pasteurisé (3)
                                </label>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#pulpe-list" data-toggle="collapse" aria-expanded="false" aria-controls="additif-list"><i class="fa fa-angle-right"></i> Pulpe</a>
                        <ul class="filter-checkbox-menu collapse" id="pulpe-list">
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Indéfini (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Sans pulpe (4)
                                </label>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#sucre-list" data-toggle="collapse" aria-expanded="false" aria-controls="additif-list"><i class="fa fa-angle-right"></i> Sucre</a>
                        <ul class="filter-checkbox-menu collapse" id="sucre-list">
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Sans sucre ajouté (4)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Indéfini (1)
                                </label>
                            </li>
                        </ul>
                    </li>
                    <li>
                        <a href="#teneur-fruit-list" data-toggle="collapse" aria-expanded="false" aria-controls="additif-list"><i class="fa fa-angle-right"></i> Teneur en fruit</a>
                        <ul class="filter-checkbox-menu collapse" id="teneur-fruit-list">
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> 100% (2)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> 75% (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> 50% (1)
                                </label>
                            </li>
                            <li>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="inlineCheckbox1" value="option1"> Indéfini (1)
                                </label>
                            </li>
                        </ul>
                    </li>
                </ul>
            </nav>